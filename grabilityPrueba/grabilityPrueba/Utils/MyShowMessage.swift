//
//  MyShowMessage.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 24/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import Foundation
import AVKit

class MyShowMessage
{
    private static let instance = MyShowMessage()
    private init() { }
    
    static func GetInstance() -> MyShowMessage
    {
        return MyShowMessage.instance
    }
    
    internal func displayNewAlert(titulo: String, mensaje: String)
    {
        let alert = UIAlertView(title: titulo, message: mensaje, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
}