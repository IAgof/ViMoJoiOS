//
//  ShareInstagramInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos

class ShareInstagramInteractor:ShareActionInterface{
    var delegate:ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(path:String){
        //Share to instagram
        let instagramURL = NSURL.init(string: "instagram://library?LocalIdentifier=\(ShareUtils().getLastAssetString())")!
        if UIApplication.sharedApplication().canOpenURL(instagramURL) {
            UIApplication.sharedApplication().openURL(instagramURL)
        }else{
            let message = Utils().getStringByKeyFromSettings(ShareConstants().NO_ISTAGRAM_INSTALLED)
            ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Instagram",
                                                            message: message)
        }
    }
}