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

class GetCompositionForVideoWorker: NSObject {
    func getComposition(_ videoPosition: Int,
                        project: Project,
                        completion: (VideoComposition) -> Void) {
        if project.getVideoList().indices.contains(videoPosition) {
            let video = project.getVideoList()[videoPosition]

            let mixComposition = AVMutableComposition()

            let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))

            // 2 - Get Video asset
            let videoAsset = AVAsset.init(url: video.videoURL)

            do {
                let startTime = kCMTimeZero
                let stopTime = videoAsset.duration
                let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)

                try videoTrack.insertTimeRange(timeRangeInsert,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                               at: kCMTimeZero)

                try audioTrack.insertTimeRange(timeRangeInsert,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                               at: kCMTimeZero)
            } catch _ {
                Utils().debugLog("Error trying to create videoTrack")
            }

            let videonaComposition = VideoComposition(mutableComposition: mixComposition)

            completion(videonaComposition)
        }

    }
}
