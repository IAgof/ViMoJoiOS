//
//  GetPHAssetFromUrl.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 20/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos

class GetPHAssetFromUrl {
    func PHAssetForFileURL(url: NSURL,completion:@escaping (PHAsset)->Void){
        let imageRequestOptions = PHImageRequestOptions()
        imageRequestOptions.version = .current
        imageRequestOptions.deliveryMode = .fastFormat
        imageRequestOptions.resizeMode = .fast
        imageRequestOptions.isSynchronous = true
        
        let fetchResult = PHAsset.fetchAssets(with: .video, options: nil)
        for  i in  0...(fetchResult.count - 1) {
            let asset = fetchResult[i]
            PHImageManager.default().requestAVAsset(forVideo: asset, options: nil, resultHandler: {
                avAsset,audioMix, info in
                
                if let urlAsset = avAsset as? AVURLAsset{
                    if urlAsset.url.absoluteString == url.absoluteString{
                        completion(asset)
                    }
                }
            })
        }
    }
}
