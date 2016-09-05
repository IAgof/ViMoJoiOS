//
//  ThumbnailInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol ThumbnailDelegate {
    func setThumbToView(image:UIImage)
}

class ThumbnailInteractor: NSObject {
    var videoPath:String!
    var diameter:CGFloat = 40.0
    var delegate:ThumbnailDelegate?
    
    init(videoPath:String,diameter:CGFloat) {
        self.videoPath = videoPath
        self.diameter = diameter
    }
    
    func getthumbnailImage(){
        var thumbnailImage = UIImage()
        
        let asset = AVURLAsset(URL: NSURL(fileURLWithPath: videoPath), options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        var cgImage:CGImage?
        do {
            cgImage =  try imgGenerator.copyCGImageAtTime(CMTime.init(value: 1, timescale: 10), actualTime: nil)
            print("Thumbnail image gets okay")
            
            thumbnailImage = UIImage(CGImage: cgImage!)
            thumbnailImage = self.resizeImage(thumbnailImage, newWidth: diameter)
            delegate?.setThumbToView(thumbnailImage)
        } catch {
            Utils.sharedInstance.debugLog("Thumbnail error \nSomething went wrong!")
            
            if let image = UIImage(named: "black_image") {
                thumbnailImage = image
                thumbnailImage = self.resizeImage(thumbnailImage, newWidth: diameter)
                delegate?.setThumbToView(thumbnailImage)
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        print("Resize image")
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newWidth))
        image.drawInRect(CGRectMake(0, 0, newWidth, newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("Finish resize image")
        return newImage
    }

}