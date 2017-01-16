//
//  GetVoiceOverComposition.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

class GetVoiceOverComposition{
    func getComposition(audios:[Audio],completion:(AVMutableComposition)->Void){
        let mutableComposition = AVMutableComposition()
        var totalAudios = audios.count
        
        for audio in audios{
            if FileManager.default.fileExists(atPath: audio.getMediaPath()){
                let url = URL(fileURLWithPath: audio.getMediaPath())
                
                let asset = AVAsset(url: url)
                
                guard let sourceAudioAssetTrack: AVAssetTrack = asset.tracks(withMediaType: AVMediaTypeAudio).first else {return}
                
                let audioCompositionTrack = mutableComposition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: kCMPersistentTrackID_Invalid)
                
                do {
                    let startTime = CMTimeMakeWithSeconds(audio.getStartTime(),600)
                    let duration = CMTimeMakeWithSeconds(audio.getDuration(),600)
                    let range = CMTimeRangeMake(kCMTimeZero, duration)
                    try audioCompositionTrack.insertTimeRange(range, of: sourceAudioAssetTrack, at: startTime)
                }catch { print(error) }
                totalAudios -= 1
                if totalAudios == 0{
                    completion(mutableComposition)
                }
            }
        }
        
        if totalAudios == 0{
            completion(mutableComposition)
        }
    }
}
