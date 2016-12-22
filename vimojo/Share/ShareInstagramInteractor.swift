//
//  ShareInstagramInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideonaProject

class ShareInstagramInteractor:ShareActionInterface{
    var delegate:ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(_ sharePath:ShareVideoPath){
        
        let url = NSURL(fileURLWithPath: sharePath.cameraRollPath)
        GetPHAssetFromUrl().PHAssetForFileURL(url: url, completion: {
            asset,isHaveFoundAsset in
            var instagramURL:URL!
            
            if isHaveFoundAsset{
                instagramURL = URL.init(string: "instagram://library?LocalIdentifier=\(asset?.localIdentifier)")!
            }else{
                instagramURL = URL.init(string: "instagram://")!
            }
            
            if UIApplication.shared.canOpenURL(instagramURL) {
                UIApplication.shared.openURL(instagramURL)
            }else{
                let message = Utils().getStringByKeyFromSettings(ShareConstants().NO_ISTAGRAM_INSTALLED)
                ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Instagram",
                                                                message: message)
            }
        })
    }
}
