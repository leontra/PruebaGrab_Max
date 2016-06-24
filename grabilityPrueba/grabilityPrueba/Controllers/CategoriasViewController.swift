//
//  CategoriasViewController.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 22/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

// MARK: - ViewController

class CategoriasViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var categoriasCollectionView: UICollectionView!
    @IBOutlet weak var imgLoader: MyLoader!
    
    var appsDictionary = [[String: AnyObject]]()
    var appsCategorias = [[String: AnyObject]]()
    var categoriasEncontradas = [String: Int]()
    
    var hasAlreadyData = false
    
    let cellIdentifier = "CellCategoria"
    let urlRequest = UrlRequest(url: "https://itunes.apple.com/us/rss/topfreeapplications/limit=", limiteABuscar: 20)
    let unwindAnimSegue = UnwindAnimation()
    let internetConnection = InternetConnection()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.imgLoader.InitMyLoader()
    }

    
    override func viewWillAppear(animated: Bool)
    {
        imgLoader.startAnimLoading()
        self.iniciarBusquedaDeDatos()
    }
    
    private func iniciarBusquedaDeDatos()
    {
        if internetConnection.hayConexionAInternet(self.hasAlreadyData )
        {
            self.iniciarBusquedaDeData()
        }
        else
        {
            self.detenerLoader()
        }
    }
    
    private func iniciarBusquedaDeData()
    {
        self.limpiarObjetosGuardados()
        self.categoriasCollectionView.reloadData()
        urlRequest.iniciarTaskDeBusqueda(CompletionHandlerBusquedaDeDatos)
    }
    
    private func limpiarObjetosGuardados()
    {
        self.appsDictionary.removeAll()
        self.appsCategorias.removeAll()
        self.categoriasEncontradas.removeAll()
    }
    
    private func CompletionHandlerBusquedaDeDatos(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void
    {
        if error == nil
        {
            self.jsonParser(data!)
        }
        else
        {
            MyShowMessage.GetInstance().displayNewAlert("Atención", mensaje: "Hubo un problema al obtener los datos, favor de intenarlo más tarde")
        }
    }
    
    private func jsonParser(data: NSData)
    {
        self.hasAlreadyData = true
        
        let parsedObject = try! NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [String: AnyObject]
        
        self.guardarObjetosEncontrados(self.obtenerDiccionarioDeDatosRecibidos(parsedObject))
        
    }
    
    private func obtenerDiccionarioDeDatosRecibidos(parsedObject: [String: AnyObject]) -> [[String:AnyObject]]
    {
        let diccionario = parsedObject["feed"] as? NSDictionary
        let objetos = diccionario!["entry"] as? [[String: AnyObject]]
        
        return objetos!
    }
    
    private func guardarObjetosEncontrados(objetos: [[String:AnyObject]])
    {
        for item in objetos
        {
            self.guardarObjeto(item)
        }
        
        self.generarTabla()
    }
    
    private func guardarObjeto(item: [String: AnyObject])
    {
        var touple = [String: AnyObject]()
        touple["data"] = item
        touple["UIImage"] = self.obtenerImagenDesdeUrl(item)
        
        let categoria = self.getCategoriaAttributes(item)
        touple["categoriaId"] = categoria["id"]
        
        self.appsDictionary.append(touple)
        self.obtenerCategoriaDelObjeto(categoria)
    }
    
    private func getCategoriaAttributes(item: [String: AnyObject]) -> [String: String]
    {
        let categoria = item["category"] as! NSDictionary
        let atributos = categoria["attributes"] as! NSDictionary
        let categoriaId = atributos["im:id"] as! String
        let categoriaLabel = atributos["label"] as! String
        return ["id": categoriaId, "label": categoriaLabel]
    }
    
    private func obtenerImagenDesdeUrl(item: NSDictionary) -> UIImage
    {
        let imgArray = item["im:image"] as! NSArray
        let imgSmall = imgArray[2]
        let imgSrc = imgSmall["label"] as! String
        let url = NSURL(string: imgSrc)
        
        if self.internetConnection.hasConnection == false
        {
            return UIImage()
        }
        
        let data = NSData(contentsOfURL: url!)!
        
        return UIImage(data: data)!
    }
    
    private func obtenerCategoriaDelObjeto(atributos: NSDictionary)
    {
        let categoriaId = atributos["id"] as! String
        if self.laCategoriaYaHaSidoRegistrada(categoriaId)
        {
            return
        }
        
        self.registrarCategoria(categoriaId, titulo: atributos["label"] as! String)
    }
    
    private func laCategoriaYaHaSidoRegistrada(categoriaId: String) -> Bool
    {
        if let value = self.categoriasEncontradas[categoriaId]
        {
            if value >= 1
            {
                return true
            }
        }
        else
        {
            self.categoriasEncontradas[categoriaId] = 1
        }
        
        return false
    }
    
    private func registrarCategoria(id: String, titulo: String)
    {
        var couple = [String:String]()
        couple["id"] = id
        couple["titulo"] = titulo
        
        self.appsCategorias.append(couple)
    }
    
    private func generarTabla()
    {
        dispatch_async(dispatch_get_main_queue(), { ()
            self.imgLoader.stopAnimLoading()
            self.categoriasCollectionView.reloadData()
        })
    }
    
    private func detenerLoader()
    {
        dispatch_async(dispatch_get_main_queue(), { ()
            self.imgLoader.stopAnimLoading()
        })
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.appsCategorias.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.cellIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        return self.prepareCollectionViewCellData(cell, index: indexPath.item)
    }
    
    private func prepareCollectionViewCellData(cell: MyCollectionViewCell, index: Int) -> UICollectionViewCell
    {
        let name = self.appsCategorias[index]["titulo"] as! String        
        cell.myLabel.text = name
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let couple = self.obtenerTodasLasAppsRelacionadasConLaCategoria(indexPath.item)
        self.performSegueWithIdentifier("idAppsListInSegue", sender: couple)
    }
    
    private func obtenerTodasLasAppsRelacionadasConLaCategoria(index: Int) -> [String: AnyObject]
    {
        let id = self.appsCategorias[index]["id"] as! String
        let categoriaTitle = self.appsCategorias[index]["titulo"] as! String
        
        var appsList = [[String: AnyObject]]()
        
        for item in self.appsDictionary
        {
            let categoriaId = item["categoriaId"] as! String
            
            if categoriaId != id && id != "0"
            {
                continue
            }
            
            appsList.append(item)
        }
        
        let couple = ["categoria": categoriaTitle, "data": appsList]
        
        return couple as! [String : AnyObject]
    }
    
    
    // MARK: - Forward Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "idAppsListInSegue")
        {
            self.mandarInformacionDeApps(segue, objeto: sender)
        }
    }
    
    private func mandarInformacionDeApps(segue: UIStoryboardSegue, objeto: AnyObject?)
    {
        let appsController = segue.destinationViewController as! AplicacionesViewController
        let data = objeto!["data"] as! [[String: AnyObject]]
        appsController.appsDictionary = data
        appsController.categoriaTitle = objeto!["categoria"] as! String
    }
    
    
    // MARK: - Unwind Segue
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue)
    {
        if sender.identifier == "segueBackCategorias"
        {
            unwindAnimSegue.terminarAnimacionDeSalida(self.view)
        }
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
