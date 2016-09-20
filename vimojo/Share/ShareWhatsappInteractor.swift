//
//  ShareWhatsappInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Social

class ShareWhatsappInteractor: ShareSocialNetworkInteractor {
    
    var documentationInteractionController:UIDocumentInteractionController!
    
    func share(){
        var debug = false
        #if DEBUG
            debug = true
        #endif
        //NSURL(string: urlString!) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "whatsapp://app")!)) || debug {
            
            let movie:NSURL = NSURL.fileURLWithPath(moviePath)
            
            //            documentationInteractionController = UIDocumentInteractionController.init(URL: movie)
            //
            //            documentationInteractionController.UTI = "public.movie"
            //
            //            documentationInteractionController.presentOpenInMenuFromRect(CGRectZero, inView: self.getViewOnTop(), animated: true)
            
            let objectsToShare = [movie] //comment!, imageData!, myWebsite!]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.setValue("Video", forKey: "subject")
            
            
            //New Excluded Activities Code
            if #available(iOS 9.0, *) {
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypeOpenInIBooks, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint]
            } else {
                // Fallback on earlier versions
                activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint ]
            }
            
            if (activityVC.popoverPresentationController != nil) {
                activityVC.popoverPresentationController!.sourceView = self.getViewOnTop()
            }
            
            self.getViewControllerOnTop().presentViewController(activityVC, animated: false, completion: nil)
            
            
        }else{
            self.setAlertCompletionMessageOnTopView(Utils().getStringByKeyFromSettings(ShareConstants().NO_WHATSAPP_INSTALLED))
        }
    }
}