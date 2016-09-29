//
//  AddTextInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class AddTextInteractor: AddTextInteractorInterface {
    var delegate:AddTextInteractorDelegate?
    var project:Project?
    var videoPosition:Int?

    init(project:Project){
        self.project = project
    }
    
    func getVideoParams() {
        guard let position = videoPosition else{return}
        guard let video = project?.getVideoList()[position]else {return}
        
        guard let text = video.textToVideo else{
            delegate?.setVideoParams("", position: 0)
            return
        }

        guard let textPosition = video.textPositionToVideo else{
            delegate?.setVideoParams("", position: 0)
            return
        }
        
        delegate?.setVideoParams(text,
                                 position: textPosition)
    }
    
    func setParametersToVideo(text: String,
                              position: Int) {
        guard let videoList = project?.getVideoList() else {return}
        
        guard let vidPosition = videoPosition else{return}
        
        videoList[vidPosition].textToVideo = text
        videoList[vidPosition].textPositionToVideo = position
        
        project?.setVideoList(videoList)
    }
    
    func setVideoPosition(position: Int) {
        self.videoPosition = position
    }
    
    func setUpComposition(completion:(AVMutableComposition)->Void) {
        var videoTotalTime:CMTime = kCMTimeZero
        
        guard let videoPos = videoPosition else {
            return
        }
        
        guard let video = project?.getVideoList()[videoPos] else{return}
        
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
        let videoAsset = AVAsset.init(URL: videoURL)
        
        do {
            let startTime = CMTimeMake(Int64(video.getStartTime() * 1000), 1000)
            let stopTime = CMTimeMake(Int64(video.getStopTime() * 1000), 1000)
            
            let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
            
            try videoTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                           atTime: kCMTimeZero)
            
            try audioTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))
            
            mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
        } catch _ {
            print("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        
        completion(mixComposition)
    }
}