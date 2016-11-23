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
    
    func setDelegate(_ delegate: SaveVideosFromGalleryDelegate) {
        self.delegate = delegate
    }
    
    func saveVideos(_ URLs: [URL]) {
        DispatchQueue.main.async(execute: { () -> Void in
            for url in URLs{
                self.saveVideoToDocuments(url)
            }
            self.delegate?.saveVideosDone()
        })
    }
    
    func saveVideoToDocuments(_ url:URL) {
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
