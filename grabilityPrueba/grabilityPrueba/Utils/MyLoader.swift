//
//  myLoader.swift
//  grabilityPrueba
//
//  Created by Maximiliano Oviedo Rosas on 24/06/16.
//  Copyright © 2016 Max Oviedo. All rights reserved.
//

import UIKit

class MyLoader: UIImageView
{
    internal func InitMyLoader()
    {
        let imgsAnim = self.getImagesAssets()
        
        self.animationImages = imgsAnim
        self.animationDuration = 1.0
        self.animationRepeatCount = 100
        self.hidden = true
    }
    
    internal func startAnimLoading()
    {
        self.startAnimating()
        self.hidden = false
    }
    
    internal func stopAnimLoading()
    {
        self.stopAnimating()
        self.hidden = true
    }
    
    private func getImagesAssets() -> [UIImage]
    {
        var imgsAnim = [UIImage]()
        for index in 0...29
        {
            imgsAnim.append(self.getNewImg(index))
        }
        
        return imgsAnim
    }
    
    private func getNewImg(index: Int) -> UIImage
    {
        var prefijo = "Preloader_8_0000"
        if index > 9
        {
            prefijo = "Preloader_8_000"
        }
        
        return UIImage(named: "\(prefijo)\(index).png")!
    }
    
}