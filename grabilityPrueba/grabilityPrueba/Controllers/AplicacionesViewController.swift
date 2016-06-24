//
//  ViewController.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 20/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

class AplicacionesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate
{
    @IBOutlet weak var objectsCollection: UICollectionView!
    @IBOutlet weak var categoriaLabel: UILabel!
    
    var appsDictionary = [[String: AnyObject]]()
    var categoriaTitle = ""

    let reuseIdentifier = "CellObject"
    let unwindAnimSegue = UnwindAnimation()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.categoriaLabel.text = categoriaTitle
        self.cargarCollection()
    }
    
    private func cargarCollection()
    {
        dispatch_async(dispatch_get_main_queue(), { ()
            self.objectsCollection.reloadData()
        })
    }
    
    // MARK: - UICollectionViewDelegate 
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.appsDictionary.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        return self.prepareCollectionViewCellData(cell, index: indexPath.item)
    }
    
    private func prepareCollectionViewCellData(cell: MyCollectionViewCell, index: Int) -> UICollectionViewCell
    {
        let nameObject = self.appsDictionary[index]["data"]!["im:name"] as! NSDictionary
        let name = nameObject["label"] as! String
        cell.myLabel.text = name
        
        let image = self.appsDictionary[index]["UIImage"] as! UIImage
        cell.imageIcon!.image = image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let data = self.appsDictionary[indexPath.item] as NSDictionary
        self.performSegueWithIdentifier("idAppDetailInSegue", sender: data)
    }
    
    
    // MARK: - Forward Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "idAppDetailInSegue")
        {
            self.mandarInformacionDeApp(segue, data: sender as! [String: AnyObject])
        }
    }
    
    private func mandarInformacionDeApp(segue: UIStoryboardSegue, data: [String:AnyObject])
    {
        let detailViewController = segue.destinationViewController as! DetallesAppViewController
        detailViewController.appData = data
    }
    
    
    // MARK: - Unwind Segue
    
    @IBAction func btnBackPush(sender: AnyObject)
    {
        self.performSegueWithIdentifier("segueBackCategorias", sender: self)
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue)
    {
        if sender.identifier == "segueBackAppsList"
        {
            unwindAnimSegue.terminarAnimacionDeSalida(self.view)
        }
        
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue
    {
        if let id = identifier
        {
            if id == "segueBackAppsList"
            {
                return unwindAnimSegue.iniciarAnimacionDeSalida(toViewController, fromViewController: fromViewController, id: id)
            }
        }
        
        return segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}

