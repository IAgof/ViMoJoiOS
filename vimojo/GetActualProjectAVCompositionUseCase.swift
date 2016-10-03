//
//  GetActualProjectAVComposition.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

class GetActualProjectAVCompositionUseCase: NSObject {
    static let sharedInstance = GetActualProjectAVCompositionUseCase()
    
    var compositionInSeconds:Double = 0.0
    
    func getComposition(project:Project) -> AVMutableComposition{
        var videoTotalTime:CMTime = kCMTimeZero

        let isMusicSet = project.isMusicSet
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        var audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        let videosArray = project.getVideoList()
        // - Add assets to the composition
        if videosArray.count>0 {
            for count in 0...(videosArray.count - 1){
                let video = videosArray[count]
                // 2 - Get Video asset
                let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
                let videoAsset = AVAsset.init(URL: videoURL)
                
                do {
                    let startTime = CMTimeMake(Int64(video.getStartTime() * 1000), 1000)

                    let stopTime = CMTimeMake(Int64(video.getStopTime() * 1000), 1000)
                    
                    try videoTrack.insertTimeRange(CMTimeRangeMake(startTime,  stopTime),
                                                   ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                                   atTime: videoTotalTime)
                    
                    if isMusicSet == false {
                        try audioTrack.insertTimeRange(CMTimeRangeMake(startTime, stopTime),
                                                       ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                                       atTime: videoTotalTime)
                    }
                    videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))

                    mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
                    Utils().debugLog("remove final range from (stopTime + videoTotalTime): \((stopTime.seconds + videoTotalTime.seconds)) \n to (videoAsset.duration + videoTotalTime): \((videoAsset.duration.seconds + videoTotalTime.seconds)) ")

                    Utils().debugLog("el tiempo total del video es: \(videoTotalTime.seconds)")
                } catch _ {
                    Utils().debugLog("Error trying to create videoTrack")
                    //                completionHandler("Error trying to create videoTrack",0.0)
                }
                
                compositionInSeconds = videoTotalTime.seconds
            }
            
            if isMusicSet{
                // 3.2 - Audio track
                // Get Audio asset
                let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(project.getMusic().getMusicResourceId(), ofType: "mp3")!)
                let audioAsset = AVAsset.init(URL: audioURL)
                
                audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: 0)
                do {
                    try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoTotalTime),
                                                   ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                                   atTime: kCMTimeZero)
                } catch _ {
                    Utils().debugLog("Error trying to create audioTrack")
                }
            }
        }
               return mixComposition
    }
    
}