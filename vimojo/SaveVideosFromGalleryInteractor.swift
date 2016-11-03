//
//  SaveVideosFromGalleryInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 3/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SaveVideosFromGalleryInteractor:NSObject,SaveVideosFromGalleryInterface{
    var delegate:SaveVideosFromGalleryDelegate?
    var project:Project?
    
    init(project:Project) {
        self.project = project
    }
    
    func setDelegate(delegate: SaveVideosFromGalleryDelegate) {
        self.delegate = delegate
    }
    
    func saveVideos(URLs: [NSURL]) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            for url in URLs{
                self.saveVideoToDocuments(url)
            }
            self.delegate?.saveVideosDone()
        })
    }
    
    func saveVideoToDocuments(url:NSURL) {
        guard var videoList = project?.getVideoList() else{
            print("Cant load video list on Save videos from gallery interactor")
            return
        }
        
        let newVideo = Video(title: "", mediaPath: "")
        newVideo.videoURL = url
        newVideo.mediaRecordedFinished()
        
        videoList.append(newVideo)
        
        project?.setVideoList(videoList)
    }
}