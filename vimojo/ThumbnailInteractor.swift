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
import VideonaProject

protocol ThumbnailDelegate {
    func setThumbToView(_ image:UIImage)
}

class ThumbnailInteractor: NSObject {
    var videoURL:URL
    var diameter:CGFloat = 40.0
    var delegate:ThumbnailDelegate?
    
    init(videoURL:URL,diameter:CGFloat) {
        self.videoURL = videoURL
        self.diameter = diameter
    }
    
    func getthumbnailImage(){
        var thumbnailImage = UIImage()
        
        let asset = AVURLAsset(url: videoURL, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        var cgImage:CGImage?
        do {
            cgImage =  try imgGenerator.copyCGImage(at: CMTime.init(value: 10, timescale: 10), actualTime: nil)
            print("Thumbnail image gets okay")
        } catch {
            Utils().debugLog("Thumbnail error \nSomething went wrong!")
            
            if let image = UIImage(named: "black_image") {
                thumbnailImage = image
                if let thumbnail = self.resizeImage(thumbnailImage, newWidth: diameter){
                    delegate?.setThumbToView(thumbnail)
                }
            }
        }
        
        thumbnailImage = UIImage(cgImage: cgImage!)
        if let thumbnail = self.resizeImage(thumbnailImage, newWidth: diameter){
            delegate?.setThumbToView(thumbnail)
        }
    }
    
    func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage? {
        print("Resize image")
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("Finish resize image")
        return newImage
    }

}
