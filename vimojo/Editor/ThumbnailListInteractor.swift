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
    var videoURL:URL
    var diameter:CGFloat = 40.0
    
    init(videoURL:URL,diameter:Int) {
        self.videoURL = videoURL
        
        let newDiameter = CGFloat.init(diameter)
        self.thumbnailImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: newDiameter, height: newDiameter))
        self.diameter = newDiameter
    }
    
    func getThumbnailImage(_ completion:(UIImage)->Void){
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        var cgImage:CGImage?
        do {
            cgImage =  try imgGenerator.copyCGImage(at: CMTime.init(value: 10, timescale: 10), actualTime: nil)
            print("Thumbnail image gets okay")
            
            // !! check the error before proceeding
            var thumbnail = UIImage(cgImage: cgImage!)
            thumbnail = self.resizeImage(thumbnail, newWidth: diameter)
            // lay out this image view, or if it already exists, set its image property to uiImage
            
            completion(thumbnail)
        } catch {
            print("Thumbnail error \nSomething went wrong!")
            completion(UIImage())
        }
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        print("Resize image")
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("Finish resize image")
        return newImage!
    }
    
}
