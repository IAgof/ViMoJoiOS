//
//  MicRecorderPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import VideonaProject

protocol MicRecorderPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
    func playerHasLoaded()
    
    func updatePlayerLayer()
    func pushBackButton()
    func cancelPushed()
    func acceptPushed()
    func cancelConfirmed()
    func removeVoiceOverTrack()
    
    func getMicRecorderViewValues()
    
    func startLongPress(atTime:CMTime)
    func pauseLongPress()
    func micInserctionPointValue(value:Float)
    func updateActualTime(_ time:Float)
    func deleteTrack()
    
    func mixVolumeUpdate(_ value:Float)
    
    func videoPlayerPlay()
    func videoPlayerPause()
    func videoPlayerSeeksTo(_ value:Float)
}

protocol MicRecorderPresenterDelegate {
    func setUpValues(_ micRecorderViewModel:MicRecorderViewModel)

    func setMicRecorderButtonState(_ state:Bool)
    func setMicRecorderButtonEnabled(_ state:Bool)
    
    func showHasRecordViews()
    func hideHasRecordViews()
    
    
    func changeAudioPlayerVolume(_ value:Float)
    func createAudioPlayer(_ composition: AVMutableComposition)
    func removeAudioPlayer()
    func playAudioPlayer()
    func pauseAudioPlayer()
    func seekAudioPlayerTo(_ value:Float)
    
    func showAlertDiscardRecord(_ title:String,
                                message:String,
                                yesString:String)
    
    func setRecordedTrackArea(value:TrackModel)
    func updateRecordedTrackArea(position:Int,
                                 value:TrackModel)
    func removeTrackArea(inPosition:Int)
    
    func recordButtonIsHidden(isHidden:Bool)
    func deleteVoiceOverTrackButtonIsHidden(isHidden:Bool)
}
