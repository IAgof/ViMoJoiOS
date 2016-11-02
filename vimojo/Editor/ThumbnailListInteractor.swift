//
//  ThumbnailListInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 26/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ThumbnailListInteractor: NSObject {
    var thumbnailImageView: UIImageView!
    var videoURL:NSURL
    var diameter:CGFloat = 40.0
    
    init(videoURL:NSURL,diameter:Int) {
        self.videoURL = videoURL
        
        let newDiameter = CGFloat.init(diameter)
        self.thumbnailImageView = UIImageView.init(frame: CGRectMake(0, 0, newDiameter, newDiameter))
        self.diameter = newDiameter
    }
    
    func getThumbnailImage(completion:(UIImage)->Void){
        let asset = AVURLAsset(URL: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        var cgImage:CGImage?
        do {
            cgImage =  try imgGenerator.copyCGImageAtTime(CMTime.init(value: 10, timescale: 10), actualTime: nil)
            print("Thumbnail image gets okay")
            
            // !! check the error before proceeding
            var thumbnail = UIImage(CGImage: cgImage!)
            thumbnail = self.resizeImage(thumbnail, newWidth: diameter)
            // lay out this image view, or if it already exists, set its image property to uiImage
            
            completion(thumbnail)
        } catch {
            print("Thumbnail error \nSomething went wrong!")
            completion(UIImage())
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