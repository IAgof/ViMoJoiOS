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
    
    func initAudioSession()
    func startRecordMic()
    func pauseRecordMic()
    func stopRecordMic()
}

protocol MicRecorderInteractorDelegate {
    func setVideoComposition(composition:AVMutableComposition)
    func setMicRecorderValues(value:MicRecorderViewModel)
}