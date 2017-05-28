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
    
    var thumbnailImage: (URL) -> (UIImage) = { videoURL in
        let defaultThumbnailImage = UIImage(color: .black, size: CGSize(width: 1024, height: 1024))
        
        let asset = AVAsset(url: videoURL)
        return asset.generateThumbnailFromAsset(forTime: CMTimeMakeWithSeconds(0.5, 600)) ?? defaultThumbnailImage
    }
}

extension AVAsset{
    /// Generate thumbnail with AVAssetImageGenerator
    func generateThumbnailFromAsset(forTime time: CMTime) -> UIImage? {
        let imageGenerator = AVAssetImageGenerator(asset: self)
        imageGenerator.appliesPreferredTrackTransform = true
        var actualTime: CMTime = kCMTimeZero
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
            let image = UIImage(cgImage: imageRef)
            return image
        } catch let error as NSError {
            print("\(error.description). Time: \(actualTime)")
            return nil
        }
    }
}
