//
//  ShareSave.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//


import Foundation
import Photos
import VideonaProject

class ShareSave:ShareActionInterface{
    var delegate:ShareActionDelegate
    var shareProject: Project
    
    init(delegate:ShareActionDelegate,
         shareProject project:Project){
        self.delegate = delegate
        self.shareProject = project
    }
    func share(_ sharePath: ShareVideoPath) {
        let message = ShareConstants.SAVE_ON_GALLERY
        ShareUtils().setAlertCompletionMessageOnTopView(socialName: "",
                                                        message: message)
    }
    
    func trackShare() {
        ViMoJoTracker.sharedInstance.trackVideoShared("Save",
                                                      videoDuration: shareProject.getDuration(),
                                                      numberOfClips: shareProject.getVideoList().count)
    }
}
