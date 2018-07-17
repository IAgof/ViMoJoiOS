//
//  SharePlatformInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 13/7/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation


import VideonaProject
import Photos

class SharePlatformInteractor: ShareActionInterface {
    var delegate: ShareActionDelegate
    var shareProject: Project
    
    init(delegate: ShareActionDelegate,
         shareProject project: Project) {
        self.delegate = delegate
        self.shareProject = project
    }
    
    func share(_ sharePath: ShareVideoPath) {
        guard let videoData = try? Data.init(contentsOf: URL(fileURLWithPath: sharePath.documentsPath)) else { return }
        let videoUpload = VideoUpload(data: videoData,
                                      title: shareProject.projectInfo.title,
                                      description: shareProject.projectInfo.description,
                                      productTypes: shareProject.projectInfo.productTypes)
        loginProvider.request(.upload(videoUpload), progress: { (progress) in
            print("progress: \(progress)")
        }) { (response) in
            self.delegate.executeFinished()
            switch response {
            case .failure(let error):
                UIApplication.topViewController()?.showWhisper(with: error.localizedDescription, color: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1))
            case .success:
                UIApplication.topViewController()?.showWhisper(with: "Video uploaded succesfully", color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))
            }
        }
    }
    
    func trackShare() {
        // TODO: Change track id
        ViMoJoTracker.sharedInstance.trackVideoShared("PlatformiOS",
                                                      videoDuration: shareProject.getDuration(),
                                                      numberOfClips: shareProject.getVideoList().count)
    }
}
