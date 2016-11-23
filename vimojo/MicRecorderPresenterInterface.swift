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

protocol MicRecorderPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
    func playerHasLoaded()
    
//    func expandPlayer()
    func updatePlayerLayer()
    func pushBackButton()
    func cancelPushed()
    func cancelConfirmed()
    
    func getMicRecorderViewValues()
    
    func startLongPress()
    func pauseLongPress()
    func acceptMicRecord()

    func updateActualTime(_ time:Float)
    
    func acceptMixAudio()
    func mixVolumeUpdate(_ value:Float)
    
    func videoPlayerPlay()
    func videoPlayerPause()
    func videoPlayerSeeksTo(_ value:Float)
}

protocol MicRecorderPresenterDelegate {
    func showMicRecordView(_ micRecorderViewModel:MicRecorderViewModel)
    func hideMicRecordView()
    
    func showMixAudioView()
    func hideMixAudioView()
    
    func setMicRecorderButtonState(_ state:Bool)
    func setMicRecorderButtonEnabled(_ state:Bool)
    
    func showAcceptCancelButton()
    func hideAcceptCancelButton()
    
    func updateRecordMicActualTime(_ time:String)
    
    func changeAudioPlayerVolume(_ value:Float)
    func createAudioPlayer(_ url: URL)
    func removeAudioPlayer()
    func playAudioPlayer()
    func pauseAudioPlayer()
    func seekAudioPlayerTo(_ value:Float)
    
    func showAlertDiscardRecord(_ title:String,
                                message:String,
                                yesString:String)
}
