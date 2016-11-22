//
//  ShareTwitterInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Accounts
import AVFoundation

class ShareTwitterInteractor: ShareActionInterface {
    var delegate:ShareActionDelegate

    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(_ path:String){
        let videoURL = ShareUtils().getLastAssetURL()
        let accountStore:ACAccountStore = ACAccountStore.init()
        let accountType:ACAccountType = accountStore.accountType(withAccountTypeIdentifier: ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccounts(with: accountType, options: nil) { (granted, error) in
            guard let accounts = accountStore.accounts(with: accountType) else{
                let message = Utils().getStringByKeyFromShare(ShareConstants().NO_TWITTER_ACCESS)
                Utils().debugLog(message)
                ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Twitter",
                                                                message: message)
                return
            }
            if accounts.count > 0 {//HAS ACCESS TO TWITTER
                
                if self.canUploadVideoToTwitter(videoURL as URL) {
                    let videoData = self.getVideoData(videoURL as URL)
                    var status = TwitterVideoUpload.instance().setVideoData(videoData)
                    TwitterVideoUpload.instance().statusContent = Utils().getStringByKeyFromShare(ShareConstants().VIDEONATIME_HASTAGH)
                    
                    if status == false {
                        self.createAlert(Utils().getStringByKeyFromShare(ShareConstants().TWITTER_MAX_SIZE))
                        return
                    }
                    
                    status = TwitterVideoUpload.instance().upload({
                        errorString in
                        var messageToPrintOnView = ""
                        
                        if (errorString != nil){
                            let codeAndMessage = self.convertStringToCodeAndMessage(errorString!)
                            messageToPrintOnView = "Error with code: \(codeAndMessage.0) \n description: \(codeAndMessage.1) "
                        }else{
                            messageToPrintOnView = Utils().getStringByKeyFromShare(ShareConstants().UPLOAD_SUCCESFULL)
                        }
                        
                        self.createAlert(messageToPrintOnView)
                    })
                }else{
                    self.createAlert(Utils().getStringByKeyFromShare(ShareConstants().TWITTER_MAX_LENGHT))
                }
            }else{
                let message = Utils().getStringByKeyFromShare(ShareConstants().NO_TWITTER_ACCESS)
                Utils().debugLog(message)
                ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Twitter",
                                                                message: message)
                
            }
        }
    }
    

    func createAlert(_ message:String){
        Utils().debugLog(message)
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Twitter",
                                                        message: message)
    }
    
    func canUploadVideoToTwitter(_ movieURL:URL)->Bool{
        let asset = AVAsset.init(url: movieURL)
        let duration = asset.duration.seconds
        
        if (duration <= 30){
            return true
        }else{
            return false
        }
    }
    
    func getVideoData(_ url:URL) -> Data {
        let path:String = url.path
            if let data = FileManager.default.contents(atPath: path){
                return data
            }else{
                return Data()
        }
    }
    
    func convertStringToCodeAndMessage(_ jsonStr:String) -> (String,String){
        let data = jsonStr.data(using: String.Encoding.ascii, allowLossyConversion: false)
        var code:Int = 0
        var message:String = ""
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
            
            if let dict = json as? [String: AnyObject] {
                if let errors = dict["errors"] as? [AnyObject] {
                    for dict2 in errors {
                        code = (dict2["code"] as? Int)!
                        message = (dict2["message"] as? String)!
                        print(code)
                        print(message)
                    }
                }
            }
            return ("\(code)" ,message)
        }
        catch {
            print(error)
            return ("","")
        }
    }
}
