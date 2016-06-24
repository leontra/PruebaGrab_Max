//
//  UrlRequest.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 24/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import Foundation

class UrlRequest
{
    var urlAConectar = ""
    var limiteDeBusqueda = 20
    let tipoDeDatoARecibir = "json"
    
    init(url: String, limiteABuscar: Int)
    {
        self.urlAConectar = url
        self.limiteDeBusqueda = limiteABuscar
    }
    
    internal func iniciarTaskDeBusqueda(completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void)
    {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(self.obtenerElURLRequestDeBusqueda(), completionHandler: completionHandler)
        task.resume()
    }
    
    private func obtenerElURLRequestDeBusqueda() -> NSURLRequest
    {
        let urlString = "\(self.urlAConectar)\(self.limiteDeBusqueda)/\(self.tipoDeDatoARecibir)"
        
        let url = NSURL(string: urlString)!
        return NSURLRequest(URL: url)
    }
}