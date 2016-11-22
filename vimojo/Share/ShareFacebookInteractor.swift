//
//  ShareFacebookInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

class ShareFacebookInteractor:NSObject, ShareActionInterface{
    var delegate:ShareActionDelegate

    // Facebook Delegate Methods
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(_ path:String){
        
        let url = ShareUtils().getLastAssetURL()
        
        let video: FBSDKShareVideo = FBSDKShareVideo()
        
        video.videoURL = url as URL!
        
        let content:FBSDKShareVideoContent = FBSDKShareVideoContent()
        content.video = video
        content.hashtag = FBSDKHashtag.init(string: Utils().getStringByKeyFromShare(ShareConstants().VIDEONATIME_HASTAGH))
        
        let dialog = FBSDKShareDialog.init()
        if UIApplication.shared.canOpenURL(URL.init(string:"fbauth2:/")!){
            dialog.mode = .native
        }else{
            let message = Utils().getStringByKeyFromSettings(ShareConstants().NO_FACEBOOK_INSTALLED)
            ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Facebook",
                                                            message: message)
        }
        dialog.shareContent = content
        dialog.delegate = self
        dialog.show()
        
    }
    
}

extension ShareFacebookInteractor:FBSDKLoginButtonDelegate{
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("loginButtonDidLogOut")
    }
}


extension ShareFacebookInteractor:FBSDKSharingDelegate{
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel")
        
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("sharerDidCancel\(error)")
        
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("didCompleteWithResults")
        
    }
}
