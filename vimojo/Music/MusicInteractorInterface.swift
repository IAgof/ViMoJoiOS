//
//  MusicInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject
import AVFoundation

protocol MusicInteractorInterface {
    func getMusicList()

    func setMusicToProject(index:Int)
    func hasMusicSelectedInProject()->Bool
    func getMusic()->Music
    func getProject()->Project
    
    func getMusicDetailParams(index:Int)
    func getMicRecorderValues()
    func getVideoComposition()
    
    func initAudioSession()
    func startRecordMic()
    func pauseRecordMic()
    func stopRecordMic()
}

protocol MusicInteractorDelegate {
    func setMusicModelList(list:[MusicViewModel])
    func setMusicDetailParams(title:String,
                              author:String,
                              image:UIImage)
    func setVideoComposition(composition:AVMutableComposition)
    func setMicRecorderValues(value:MicRecorderViewModel)
}