//
//  ShareWhatsappInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Social

class ShareWhatsappInteractor: ShareActionInterface {
    var delegate:ShareActionDelegate

    var documentationInteractionController:UIDocumentInteractionController!
    
    init(delegate:ShareActionDelegate){
        self.delegate = delegate
    }
    
    func share(path:String){
        var debug = false
        #if DEBUG
            debug = true
        #endif
        //NSURL(string: urlString!) {
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string: "whatsapp://app")!)) || debug {
            
            let movie:NSURL = NSURL.fileURLWithPath(path)
            guard let viewController = UIApplication.topViewController() else{return}
            
            documentationInteractionController = UIDocumentInteractionController.init(URL: movie)
            
            documentationInteractionController.UTI = "public.movie"
            
            documentationInteractionController.presentOpenInMenuFromRect(CGRectZero, inView: viewController.view, animated: true)
            
            let objectsToShare = [movie] //comment!, imageData!, myWebsite!]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.setValue("Video", forKey: "subject")
            
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeMail, UIActivityTypeMessage, UIActivityTypeOpenInIBooks, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypePostToWeibo, UIActivityTypePrint]

            
            if (activityVC.popoverPresentationController != nil) {
                let view = viewController.view
                
                activityVC.popoverPresentationController!.sourceView = view
            }
            
            viewController.presentViewController(activityVC, animated: false, completion: nil)
            
            
        }else{
            let message = Utils().getStringByKeyFromSettings(ShareConstants().NO_WHATSAPP_INSTALLED)
            ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Whatsapp",
                                                            message: message)
        }
    }
}