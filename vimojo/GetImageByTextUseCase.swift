//
//  GetImageByTextUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation



class GetImageByTextUseCase {
    func getTextImage(text:String,
                      attributes:CATextLayerAttributes)->UIImage{
        
        let horizontalOffset :CGFloat = 10.0
        let frame = CGRectMake(horizontalOffset, 0, 1920, 1080)
        
        let parentLayer = CALayer()
        parentLayer.frame = frame
        
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.font = attributes.font
        textLayer.fontSize = attributes.fontSize
        
        textLayer.alignmentMode = attributes.horizontalAlignment.rawValue
        
        textLayer.frame = attributes.getFrameForString(frame)
        
        parentLayer.addSublayer(textLayer)
        
        let image = UIImage.imageWithLayer(parentLayer)
        
        return image
    }
}

extension UIImage {
    class func imageWithLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 1920, height: 1080), layer.opaque, 0.0)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}