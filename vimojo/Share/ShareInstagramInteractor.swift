//
//  ShareInstagramInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 6/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideonaProject

class ShareInstagramInteractor: ShareActionInterface {
    var delegate: ShareActionDelegate
    var shareProject: Project

    init(delegate: ShareActionDelegate,
         shareProject project: Project) {
        self.delegate = delegate
        self.shareProject = project
    }
    func share(_ sharePath: ShareVideoPath) {
        trackShare()

        let url = NSURL(fileURLWithPath: sharePath.cameraRollPath)
        GetPHAssetFromUrl().PHAssetForFileURL(url: url, completion: {
            asset, isHaveFoundAsset in
            var instagramURL: URL!

            if isHaveFoundAsset {
                if let localIdentifier = asset?.localIdentifier {
                    instagramURL = URL.init(string: "instagram://library?LocalIdentifier=\(localIdentifier)")!
                } else {
                    instagramURL = URL.init(string: "instagram://")!
                }
            } else {
                instagramURL = URL.init(string: "instagram://")!
            }

            if UIApplication.shared.canOpenURL(instagramURL) {
                UIApplication.shared.openURL(instagramURL)
            } else {
                let message = ShareConstants.NO_ISTAGRAM_INSTALLED
                ShareUtils().setAlertCompletionMessageOnTopView(socialName: "Instagram",
                                                                message: message)
            }
        })
    }

    func trackShare() {
        ViMoJoTracker.sharedInstance.trackVideoShared("Instagram",
                                                      videoDuration: shareProject.getDuration(),
                                                      numberOfClips: shareProject.getVideoList().count)
    }
}
