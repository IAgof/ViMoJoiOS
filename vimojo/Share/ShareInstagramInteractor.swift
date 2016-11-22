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
    
    func share(_ path:String){
        //Share to instagram
        let instagramURL = URL.init(string: "instagram://library?LocalIdentifier=\(ShareUtils().getLastAssetString())")!
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.openURL(instagramURL)
        }else{
            let message = Utils().getStringByKeyFromSettings(ShareConstants().NO_ISTAGRAM_INSTALLED)
            ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Instagram",
                                                            message: message)
        }
    }
}
