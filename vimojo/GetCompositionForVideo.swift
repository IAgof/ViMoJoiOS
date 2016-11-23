//
//  GetCompositionForVideoWorker.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class GetCompositionForVideoWorker: NSObject{
    func getComposition(videoPosition:Int,
                               project:Project,
                               completion:(VideoComposition)->Void) {
        let video = project.getVideoList()[videoPosition]
        
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        let videoAsset = AVAsset.init(URL: video.videoURL)
        
        do {
            let startTime = kCMTimeZero
            let stopTime = videoAsset.duration
            let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
            
            try videoTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                           atTime: kCMTimeZero)
            
            try audioTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
        } catch _ {
            Utils.sharedInstance.debugLog("Error trying to create videoTrack")
        }
        
        let videonaComposition = VideoComposition(mutableComposition: mixComposition)
        
        completion(videonaComposition)
    }
}