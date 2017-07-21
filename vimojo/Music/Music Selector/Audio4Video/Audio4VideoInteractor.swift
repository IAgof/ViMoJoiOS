//
//  Audio4VideoInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

protocol Audio4VideoInteractorInterface {
    var project: Project?{get set}
    var audioValue: Float?{ get set}
    func getVideoComposition()
    func resetAudio()
    var initialAudio: Float { get }
}

class Audio4VideoInteractor: Audio4VideoInteractorInterface {
    var project: Project?
    var delegate: Audio4VideoInteractorDelegate?
    var video: Video?
    var initialAudio: Float = 1.0
    var audioValue: Float?{
        didSet{
            if oldValue != nil, let audioValue = audioValue{
                video?.audioLevel = audioValue
                updateAudio()
            }
        }
    }
    
    func setup(delegate: Audio4VideoInteractorDelegate, project: Project, video: Video) {
        self.delegate = delegate
        self.project = project
        self.video = video
        self.initialAudio = video.audioLevel
    }
    
    func getVideoComposition() {
        guard let video = self.video else{ return }
        delegate?.setVideoComposition(VideoComposition.composition(video, project))
    }
    
    private func updateAudio() {
        guard let video = self.video,
            let audioMix = VideoComposition.composition(video, project).audioMix else{ return }
        delegate?.updateAudioMix(audioMix: audioMix)
    }
    
    func resetAudio() {
        video?.audioLevel = initialAudio
    }
}

//TODO: Move to SDK
extension VideoComposition{
   static var composition: (Video, Project?) -> VideoComposition {
        return { video, project in
            let mixComposition = AVMutableComposition()
            let audioMix: AVMutableAudioMix = AVMutableAudioMix()
            var audioMixParam: [AVMutableAudioMixInputParameters] = []
     
            let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                            preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
            let videoAsset = AVAsset.init(url: video.videoURL)
            
            do {
                let startTime = CMTimeMake(Int64(video.getStartTime() * 600), 600)
                let stopTime = CMTimeMake(Int64(video.getStopTime() * 600), 600)
                let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
                
                try videoTrack.insertTimeRange(timeRangeInsert,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                               at: kCMTimeZero)
                
                try audioTrack.insertTimeRange(timeRangeInsert,
                                               of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                               at: kCMTimeZero)
                let audiocParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: audioTrack)
                audiocParam.trackID = audioTrack.trackID
                audiocParam.setVolume(video.audioLevel * (project?.projectOutputAudioLevel ?? 1), at: kCMTimeZero)
                audioMixParam.append(audiocParam)
                audioMix.inputParameters = audioMixParam
            } catch _ {
                debugPrint("Error trying to create videoTrack")
            }
            let videoComposition = VideoComposition(mutableComposition: mixComposition)
            videoComposition.audioMix = audioMix
            return videoComposition
        }
    }
}
