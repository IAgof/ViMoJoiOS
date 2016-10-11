//
//  MicRecorderPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol MicRecorderPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
    func playerHasLoaded()
    
//    func expandPlayer()
    func updatePlayerLayer()
    func pushBackButton()

    func getMicRecorderViewValues()
    
    func startLongPress()
    func pauseLongPress()
    func acceptMicRecord()
    func cancelMicRecord()
    func updateActualTime(time:Float)
}

protocol MicRecorderPresenterDelegate {
    func showMicRecordView(micRecorderViewModel:MicRecorderViewModel)
    func hideMicRecordView()
    
    func setMicRecorderButtonState(state:Bool)
    func setMicRecorderButtonEnabled(state:Bool)
    
    func showAcceptCancelButton()
    func hideAcceptCancelButton()
    
    func updateRecordMicActualTime(time:String)
}