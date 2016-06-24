//
//  ListadoAppsViewController.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 20/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

class DetallesAppViewController: UIViewController
{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgApp: UIImageView!
    @IBOutlet weak var descripcionViewText: UITextView!
    @IBOutlet weak var categoriaLabel: UILabel!
    @IBOutlet weak var vendedorLabel: UILabel!
    @IBOutlet weak var derechosLabel: UILabel!
    @IBOutlet weak var anoLanzamientoLabel: UILabel!
    
    internal var appData = [String: AnyObject]()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setAppImage()
        self.setAppProperties()
    }
    
    private func setAppImage()
    {
        let image = self.appData["UIImage"] as! UIImage
        self.imgApp.image = image
    }
    
    private func setAppProperties()
    {
        let data = self.appData["data"] as! NSDictionary
        
        self.titleLabel.text = self.getAppProperty(data, property: "im:name")
        self.descripcionViewText.text = self.getAppProperty(data, property: "summary")
        self.categoriaLabel.text = self.getAppPropertyWithAttribute(data, property: "category", attribute: "attributes")
        self.vendedorLabel.text = self.getAppProperty(data, property: "im:artist")
        self.derechosLabel.text = self.getAppProperty(data, property: "rights")
        self.anoLanzamientoLabel.text = self.getAppPropertyWithAttribute(data, property: "im:releaseDate", attribute: "attributes")
    }
    
    private func getAppProperty(data: NSDictionary, property: String) -> String
    {
        let property = data[property] as! NSDictionary
        let propertyValue = property["label"] as! String
        return propertyValue
    }
    
    private func getAppPropertyWithAttribute(data: NSDictionary, property: String, attribute: String) -> String
    {
        let property = data[property] as! NSDictionary
        let attributes = property[attribute] as! NSDictionary
        let propertyValue = attributes["label"] as! String
        return propertyValue
    }
    
    @IBAction func btnBackPush(sender: AnyObject)
    {
        self.performSegueWithIdentifier("segueBackAppsList", sender: self)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}
