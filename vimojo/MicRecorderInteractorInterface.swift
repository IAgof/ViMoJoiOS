//
//  MicRecorderInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject
import AVFoundation

protocol MicRecorderInteractorInterface {
    func getMicRecorderValues()
    func getVideoComposition()
    func loadVoiceOverAudios()
    
    func startRecordMic(atTime:CMTime)
    func pauseRecordMic()
    func stopRecordMic()
    
    func getActualAudioRecorded()
    
    func setVoiceOverToProject(_ videoVolume:Float,
                               audioVolume:Float)
    func removeVoiceOverFromProject()
    func getStringByKey(_ key:String) -> String
}

protocol MicRecorderInteractorDelegate {
    func setVideoComposition(_ composition:VideoComposition)
    func setMicRecorderValues(_ value:MicRecorderViewModel)
    func setActualAudioRecorded(_ voiceOverComposition:AVMutableComposition)
    
    func setMicRecordedTimeRangeValue(micRecordedRange: CMTimeRange) 
}
