//
//  StoryboardAnimSegueIn.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 23/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

class StoryboardAnimSegueIn: UIStoryboardSegue
{
    override func perform()
    {
        let fromViewController = self.sourceViewController.view as UIView!
        let toViewController = self.destinationViewController.view as UIView!
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        toViewController.frame = CGRectMake(0.0, screenHeight, screenWidth, screenHeight)
        
        let window = UIApplication.sharedApplication().keyWindow
        window?.insertSubview(toViewController, aboveSubview: fromViewController)
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
            
            fromViewController.frame = CGRectOffset(fromViewController.frame, 0.0, -screenHeight)
            toViewController.frame = CGRectOffset(toViewController.frame, 0.0, -screenHeight)
            
        }, completion: { (Finished) -> Void in
            
            self.sourceViewController.presentViewController(self.destinationViewController as UIViewController, animated: false, completion: nil)
        })
        
    }
}
