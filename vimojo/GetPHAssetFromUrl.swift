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
    func PHAssetForFileURL(url: NSURL,completion:@escaping (_ asset:PHAsset?,_ isHaveFound:Bool)->Void){
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
                    let urlAssetAbsString = (urlAsset.url.absoluteString as NSString).lastPathComponent
                    let urlAbsString = (url.absoluteString! as NSString).lastPathComponent
                   
                    if urlAssetAbsString == urlAbsString{
                        completion(asset,true)
                    }else{
                        if i == (fetchResult.count - 1){
                            completion(nil,false)
                        }
                    }
                }
            })
        }
    }
    
    func PHAssetForFiles(withURLs urls:[NSURL],completion:@escaping (_ assets:[PHAsset])->Void){
        var count = urls.count
        var assets:[PHAsset] = []
        for url in urls{
            self.PHAssetForFileURL(url: url, completion: {
                asset,isHaveFoundAsset in
                if isHaveFoundAsset{
                    if let asset = asset{
                        assets.append(asset)
                        count -= 1
                        if count == 0{
                            completion(assets)
                        }
                    }
                }
            })
        }
    }
}
