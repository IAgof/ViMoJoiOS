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
    
    func setAlertCompletionMessageOnTopView(socialName socialName:String,
                                            message:String){
        let alertController = UIAlertController(title: socialName, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: Utils().getStringByKeyFromShare(ShareConstants().OK),
            style: .Default, handler: nil))
        
        let controller = UIApplication.topViewController()
        if let shareController = controller as? EditingRoomViewController {
            shareController.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    
    func getViewOnTop()->UIView{
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController.view
            // topController should now be your topmost view controller
        }else{
            return (UIApplication.sharedApplication().keyWindow?.rootViewController)!.view
        }
    }
    
    func createAlertWaitToExport(){
        let alertController = UIAlertController(title: Utils().getStringByKeyFromShare(ShareConstants().UPLOADING_VIDEO),
                                            message: Utils().getStringByKeyFromShare(ShareConstants().PLEASE_WAIT),
                                            preferredStyle: .Alert)
        
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        
        activityIndicator.center = CGPointMake(130.5, 75.5);
        activityIndicator.startAnimating()
        
        alertController.view.addSubview(activityIndicator)
        
        let controller = UIApplication.topViewController()
        if let shareController = controller as? EditingRoomViewController {
            shareController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func dissmissAlertWaitToExport(completion:()->Void){
//        alertController?.dismissViewControllerAnimated(true, completion: {
//            print("can go to next screen")
//            completion()
//        })
    }
    
    func getLastAsset() -> PHAsset
    {
        var asset:PHAsset = PHAsset()
        
        //Get last videoAsset on PhotoLibrary
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending:false)]
        let fetchResult = PHAsset.fetchAssetsWithMediaType(.Video, options: fetchOptions)
       
        if let lastAsset = fetchResult.firstObject as? PHAsset {
            asset = lastAsset
        }
        return asset
    }
    
    func getLastAssetURL() ->NSURL{
        let asset = self.getLastAsset()
        let localID = asset.localIdentifier
        let assetID =
            localID.stringByReplacingOccurrencesOfString(
                "/.*", withString: "",
                options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        let ext = "mp4"
        let assetURLStr =
            "assets-library://asset/asset.\(ext)?id=\(assetID)&ext=\(ext)"
        
        return NSURL(string: assetURLStr)!
    }
    
    func getLastAssetString() -> String{
        let asset = self.getLastAsset()
        
        return asset.localIdentifier
    }
}