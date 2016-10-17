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
    
    func getComposition(project:Project) -> VideoComposition{
        var videoTotalTime:CMTime = kCMTimeZero

        let isMusicSet = project.isMusicSet
        let isVoiceOverSet = project.isVoiceOverSet
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()

        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        var videoComposition:AVMutableVideoComposition?
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
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
                        let videoParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                        videoParam.trackID = audioTrack.trackID
                        videoParam.setVolume(project.projectOutputAudioLevel, atTime: kCMTimeZero)
                        audioMixParam.append(videoParam)
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
                setMusicToProject(mixComposition,
                                  musicPath: project.getMusic().getMusicResourceId())
            }
            
            if isVoiceOverSet {
                setVoiceOverToProject(audioMixParam,
                                      mixComposition: mixComposition,
                                      audioPath: project.voiceOver.getMediaPath(),
                                      audioLevel: project.voiceOver.audioLevel)
            }
        }
        
        
        var playerComposition = VideoComposition(mutableComposition: mixComposition)
        
        audioMix.inputParameters = audioMixParam
        playerComposition.audioMix = audioMix
        
        if videoComposition != nil{
            playerComposition.videoComposition = videoComposition
        }
        
        return playerComposition
    }
    
    
    func setMusicToProject(mixComposition:AVMutableComposition,
                           musicPath:String){
        let audioURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicPath, ofType: "mp3")!)
        let audioAsset = AVAsset.init(URL: audioURL)
        
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, mixComposition.duration),
                                           ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
        } catch _ {
            Utils().debugLog("Error trying to create audioTrack")
        }
    }
    
    func setVoiceOverToProject(mixAudioParams:[AVMutableAudioMixInputParameters],
                               mixComposition:AVMutableComposition,
                               audioPath:String,
                               audioLevel:Float){
        var audioParams = mixAudioParams

        let audioURL = NSURL.init(fileURLWithPath: audioPath)
        let audioAsset = AVAsset.init(URL: audioURL)
        
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                 preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        do {
            try audioTrack.insertTimeRange(CMTimeRangeMake(kCMTimeZero, audioAsset.duration),
                                           ofTrack: audioAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            let voiceOverParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
            voiceOverParam.trackID = audioTrack.trackID
            voiceOverParam.setVolume(audioLevel, atTime: kCMTimeZero)
            audioParams.append(voiceOverParam)
        } catch _ {
            Utils().debugLog("Error trying to create audioTrack")
        }
    }
}


///**
// volume: between 1.0 and 0.0
// */
//class func mergeVideoAndMusicWithVolume(videoURL: NSURL, audioURL: NSURL, startAudioTime: Float64, volumeVideo: Float, volumeAudio: Float, complete: (NSURL?) -> Void) -> Void {
//    
//    //The goal is merging a video and a music from iPod library, and set it a volume
//    
//    //Get the path of App Document Directory
//    let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//    let docsDir = dirPaths[0] as String
//    
//    //Create Asset from record and music
//    let assetVideo: AVURLAsset = AVURLAsset(URL: videoURL)
//    let assetMusic: AVURLAsset = AVURLAsset(URL: audioURL)
//    
//    let composition: AVMutableComposition = AVMutableComposition()
//    
//    let compositionVideo: AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
//    let compositionAudioVideo: AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
//    let compositionAudioMusic: AVMutableCompositionTrack = composition.addMutableTrackWithMediaType(AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
//    
//    //Add video to the final record
//    do {
//        try compositionVideo.insertTimeRange(CMTimeRangeMake(kCMTimeZero, assetVideo.duration), ofTrack: assetVideo.tracksWithMediaType(AVMediaTypeVideo)[0], atTime: kCMTimeZero)
//    } catch _ {
//    }
//    
//    //Extract audio from the video and the music
//    let audioMix: AVMutableAudioMix = AVMutableAudioMix()
//    var audioMixParam: [AVMutableAudioMixInputParameters] = []
//    
//    let assetVideoTrack: AVAssetTrack = assetVideo.tracksWithMediaType(AVMediaTypeAudio)[0]
//    let assetMusicTrack: AVAssetTrack = assetMusic.tracksWithMediaType(AVMediaTypeAudio)[0]
//    
//    let videoParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetVideoTrack)
//    videoParam.trackID = compositionAudioVideo.trackID
//    
//    let musicParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: assetMusicTrack)
//    musicParam.trackID = compositionAudioMusic.trackID
//    
//    //Set final volume of the audio record and the music
//    videoParam.setVolume(volumeVideo, atTime: kCMTimeZero)
//    musicParam.setVolume(volumeAudio, atTime: kCMTimeZero)
//    
//    //Add setting
//    audioMixParam.append(musicParam)
//    audioMixParam.append(videoParam)
//    
//    //Add audio on final record
//    //First: the audio of the record and Second: the music
//    do {
//        try compositionAudioVideo.insertTimeRange(CMTimeRangeMake(kCMTimeZero, assetVideo.duration), ofTrack: assetVideoTrack, atTime: kCMTimeZero)
//    } catch _ {
//        assertionFailure()
//    }
//    
//    do {
//        try compositionAudioMusic.insertTimeRange(CMTimeRangeMake(CMTimeMake(Int64(startAudioTime * 10000), 10000), assetVideo.duration), ofTrack: assetMusicTrack, atTime: kCMTimeZero)
//    } catch _ {
//        assertionFailure()
//    }
//    
//    //Add parameter
//    audioMix.inputParameters = audioMixParam
//    
//    //Remove the previous temp video if exist
//    let filemgr = NSFileManager.defaultManager()
//    do {
//        if filemgr.fileExistsAtPath("\(docsDir)/movie-merge-music.mov") {
//            try filemgr.removeItemAtPath("\(docsDir)/movie-merge-music.mov")
//        } else {
//        }
//    } catch _ {
//    }
//    
//    //Exporte the final record’
//    let completeMovie = "\(docsDir)/movie-merge-music.mov"
//    let completeMovieUrl = NSURL(fileURLWithPath: completeMovie)
//    let exporter: AVAssetExportSession = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
//    exporter.outputURL = completeMovieUrl
//    exporter.outputFileType = AVFileTypeMPEG4
//    exporter.audioMix = audioMix
//    
//    exporter.exportAsynchronouslyWithCompletionHandler({
//        switch exporter.status{
//        case  AVAssetExportSessionStatus.Failed:
//            print("failed \(exporter.error)")
//            complete(nil)
//        case AVAssetExportSessionStatus.Cancelled:
//            print("cancelled \(exporter.error)")
//            complete(nil)
//        default:
//            print("complete")
//            complete(completeMovieUrl)
//        }
//    })
//}