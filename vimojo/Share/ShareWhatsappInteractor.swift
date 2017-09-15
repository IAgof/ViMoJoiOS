//
//  ShareWhatsappInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Social
import VideonaProject

class ShareWhatsappInteractor: ShareActionInterface {
    var delegate: ShareActionDelegate
    var shareProject: Project

    var documentationInteractionController: UIDocumentInteractionController!

    init(delegate: ShareActionDelegate,
         shareProject project: Project) {
        self.delegate = delegate
        self.shareProject = project
    }

    func share(_ sharePath: ShareVideoPath) {
        var debug = false
        #if DEBUG
            debug = true
        #endif
        //NSURL(string: urlString!) {
        if (UIApplication.shared.canOpenURL(URL(string: "whatsapp://app")!)) || debug {
            trackShare()

            let movie: URL = URL(fileURLWithPath: sharePath.documentsPath)
            guard let viewController = UIApplication.topViewController() else {return}

            documentationInteractionController = UIDocumentInteractionController.init(url: movie)

            documentationInteractionController.uti = "public.movie"

            documentationInteractionController.presentOpenInMenu(from: CGRect.zero, in: viewController.view, animated: true)

            let objectsToShare = [movie] //comment!, imageData!, myWebsite!]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            activityVC.setValue("Video", forKey: "subject")

            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.mail, UIActivityType.message, UIActivityType.openInIBooks, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.postToWeibo, UIActivityType.print]

            if (activityVC.popoverPresentationController != nil) {
                let view = viewController.view

                activityVC.popoverPresentationController!.sourceView = view
            }

            viewController.present(activityVC, animated: false, completion: nil)

        } else {
            let message = ShareConstants.NO_WHATSAPP_INSTALLED
            ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Whatsapp",
                                                            message: message)
        }
    }

    func trackShare() {
        ViMoJoTracker.sharedInstance.trackVideoShared("Whatsapp",
                                                      videoDuration: shareProject.getDuration(),
                                                      numberOfClips: shareProject.getVideoList().count)
    }
}
