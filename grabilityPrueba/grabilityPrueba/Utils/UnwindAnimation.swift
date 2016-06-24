//
//  UnwindAnimation.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 24/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import Foundation
import AVKit

class UnwindAnimation
{
    internal func iniciarAnimacionDeSalida(toViewController: UIViewController, fromViewController: UIViewController, id: String) -> UIStoryboardSegue
    {
        let unwindSegue = StoryboardAnimSegueOut(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
        })
        
        return unwindSegue
    }
    
    internal func terminarAnimacionDeSalida(view: UIView)
    {
        let originalColor = view.backgroundColor
        view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.9)
        
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            view.backgroundColor = originalColor
        })
    }
}
