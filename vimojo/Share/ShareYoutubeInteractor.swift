//
//  ShareYoutubeInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Alamofire
import GoogleSignIn

class ShareYoutubeInteractor: ShareActionInterface{
    var viewControllerOnTop:UIViewController?
    var mediaPath:String?
    var delegate:ShareActionDelegate
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
        
        viewControllerOnTop = UIApplication.topViewController()
    }
    
    func share(path:String){
        let youtubeScope = "https://www.googleapis.com/auth/youtube.upload"
        let youtubeScope2 = "https://www.googleapis.com/auth/youtube"
        let youtubeScope3 = "https://www.googleapis.com/auth/youtubepartner"
        
        GIDSignIn.sharedInstance().scopes.append(youtubeScope)
        GIDSignIn.sharedInstance().scopes.append(youtubeScope2)
        GIDSignIn.sharedInstance().scopes.append(youtubeScope3)
        
        GIDSignIn.sharedInstance().signIn()
        
        mediaPath = path
    }
    
    
    
    //MARK: - Youtube upload
    func postVideoToYouTube( token:String, callback: Bool -> Void){
        
        let headers = ["Authorization": "Bearer \(token)"]
        
        let title = "Videona-\(Utils().giveMeTimeNow())"
        let description = Utils().getStringByKeyFromShare(ShareConstants().YOUTUBE_DESCRIPTION)
        
        guard let path = mediaPath else {return}
        let videoData = NSData.init(contentsOfFile: path)
        Alamofire.upload(
            .POST,
            "https://www.googleapis.com/upload/youtube/v3/videos?part=snippet",
            headers: headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data:"{'snippet':{'title' : '\(title)', 'description': '\(description)'}}".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"snippet", mimeType: "application/json")
                
                multipartFormData.appendBodyPart(data: videoData!, name: "video", fileName: "video.mp4", mimeType: "application/octet-stream")
                
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        print(response)
                        callback(true)
                        
                        let message = Utils().getStringByKeyFromShare(ShareConstants().UPLOAD_SUCCESFULL)
                        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Youtube", message: message)
                    }
                case .Failure(_):
                    callback(false)
                    let message = Utils().getStringByKeyFromShare(ShareConstants().UPLOAD_FAIL)
                    ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Youtube", message: message)
                }
        })
    }
}

extension ShareViewController:GIDSignInUIDelegate,GIDSignInDelegate{

    //MARK: - Google methods
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        //        myActivityIndicator.stopAnimating()
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        
        self.presentViewController(viewController, animated: false, completion: nil)
        
        Utils().debugLog("SignIn")
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        Utils().debugLog("SignIn Dissmiss")
        
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        Utils().debugLog("Google Sign In get user token")
        
        //Error control
        if (error == nil) {
            token = user.authentication.accessToken
            
            Utils().debugLog("Google Sign In get user token: \(token))")
            
            eventHandler!.postToYoutube(token)
        } else {
            Utils().debugLog("\(error.localizedDescription)")
        }
    }
}