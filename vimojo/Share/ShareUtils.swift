//
//  ShareSocialNetworkInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideonaProject

class ShareUtils{
    
    func setAlertCompletionMessageOnTopView(socialName:String,
                                            message:String){
        let alertController = UIAlertController(title: socialName, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Utils().getStringByKeyFromShare(ShareConstants().OK),
            style: .default, handler: nil))
        
        let controller = UIApplication.topViewController()
        if let shareController = controller as? EditingRoomViewController {
            shareController.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func getViewOnTop()->UIView{
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
            // topController should now be your topmost view controller
        }else{
            return (UIApplication.shared.keyWindow?.rootViewController)!.view
        }
    }
    
    func getLastAsset() -> PHAsset
    {
        var asset:PHAsset = PHAsset()
        
        //Get last videoAsset on PhotoLibrary
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending:false)]
        let fetchResult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
       
        if let lastAsset = fetchResult.firstObject  {
            asset = lastAsset
        }
        return asset
    }
    
    func createAlertViewWithInputText(_ title:String,
                                      message:String,
                                      completion: @escaping (String) -> Void)-> UIAlertController{
        
        let saveString = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_SAVE)
        let cancelString = Utils().getStringByKeyFromShare(ShareConstants().FTP_INPUT_FILENAME_CANCEL)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = message
        }
        
        let saveAction = UIAlertAction(title: saveString, style: .default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func getLastAssetURL() ->URL{
        let asset = self.getLastAsset()
        let localID = asset.localIdentifier
        let assetID =
            localID.replacingOccurrences(
                of: "/.*", with: "",
                options: NSString.CompareOptions.regularExpression, range: nil)
        let ext = "mp4"
        let assetURLStr =
            "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"
        
        return URL(string: assetURLStr)!
    }
    
    func getLastAssetString() -> String{
        let asset = self.getLastAsset()
        
        return asset.localIdentifier
    }
}
