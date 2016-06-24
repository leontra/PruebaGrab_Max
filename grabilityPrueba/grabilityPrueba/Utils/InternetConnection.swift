//
//  InternetConnection.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 23/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import Foundation
import AVKit
import SystemConfiguration

class InternetConnection
{
    var haveShownOfflineMsg = false
    var hasConnection = false
    
    internal func hayConexionAInternet(yaTieneDatosAlmacenados : Bool) -> Bool
    {
        if self.isConnectedToNetwork() == false
        {
            if self.haveShownOfflineMsg
            {
                return false
            }
            else if yaTieneDatosAlmacenados
            {
                MyShowMessage.GetInstance().displayNewAlert("Sin conección a internet", mensaje: "Por ahora estás en modo offline")
            }
            else
            {
                MyShowMessage.GetInstance().displayNewAlert("Sin conección a internet", mensaje: "No se ha podido obtener la información")
            }
            
            self.hasConnection = false
            self.haveShownOfflineMsg = true
            return false
        }
        else
        {
            self.haveShownOfflineMsg = false
            self.hasConnection = true
            return true
        }
    }
    
    private func isConnectedToNetwork() -> Bool
    {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
    }    
}
