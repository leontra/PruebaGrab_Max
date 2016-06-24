//
//  StoryboardAnimSegueOut.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 23/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

class StoryboardAnimSegueOut: UIStoryboardSegue
{
    override func perform()
    {
        let toViewController = self.sourceViewController.view as UIView!
        let fromViewController = self.destinationViewController.view as UIView!
        
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(fromViewController, aboveSubview: toViewController)
        
        UIView.animateWithDuration(0.6, animations:
        { () -> Void in
            
            fromViewController.frame = CGRectOffset(fromViewController.frame, 0.0, screenHeight)
            toViewController.frame = CGRectOffset(toViewController.frame, 0.0, screenHeight)
            
        }) { (Finished) -> Void in
            
                self.sourceViewController.dismissViewControllerAnimated(false, completion: nil)
                
        }
    }    
}
