//
//  MusicPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol MusicPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
    func didSelectMusicAtIndexPath(indexPath:NSIndexPath)
    func cancelDetailButtonPushed()
    func acceptDetailButtonPushed()
    func removeDetailButtonPushed()
    
    func setMusicDetailInterface(eventHandler:MusicDetailInterface)
    
    func expandPlayer()
    func updatePlayerLayer()
    
    func pushMusicHandler()
    func pushMicHandler()
    func getMusicList()
    
    func getMicRecorderViewValues()
    
    func startLongPress()
    func pauseLongPress()
    func acceptMicRecord()
    func cancelMicRecord()
    func updateActualTime(time:Float)
}

protocol MusicPresenterDelegate {
    func setMusicList(list:[MusicViewModel])
    
    func showTableView()
    func hideTableView()
    
    func showDetailView(title:String,
                        author:String,
                        image:UIImage)
    func hideDetailView()
    
    func showMicRecordView(micRecorderViewModel:MicRecorderViewModel)
    func hideMicRecordView()
    
    func setMicRecorderButtonState(state:Bool)
    func setMicRecorderButtonEnabled(state:Bool)
    
    func showMicRecorderAcceptCancelButton()
    func updateRecordMicActualTime(time:String)
}