//
//  MicRecorderPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer
import AVFoundation

class MicRecorderPresenter: MicRecorderPresenterInterface,MicRecorderInteractorDelegate {
    //MARK: - Variables VIPER
    var delegate:MicRecorderPresenterDelegate?
    var interactor: MicRecorderInteractorInterface?
    var wireframe: MicRecorderWireframe?
    
    var detailEventHandler: MusicDetailInterface?
    
    var playerPresenter: PlayerPresenterInterface?
    
    //MARK: - Variables
    var lastMusicSelected:Int = -1
    var isMusicSet:Bool = false
    var isGoingToExpandPlayer = false
    var recordMicViewActualTime = 0.0
    var recordMicViewTotalTime = 0.0
    
    //MARK: - Constants
    let NO_MUSIC_SELECTED = -1
    
    //MARK: - Interface
    func viewDidLoad() {
        wireframe?.presentPlayerInterface()
        
        interactor?.getVideoComposition()
        interactor?.initAudioSession()
        interactor?.getMicRecorderValues()
        
    }
    
    func viewWillAppear() {
//        delegate?.bringToFrontExpandPlayerButton()
    }
    
    func viewDidAppear() {
        playerPresenter?.disablePlayerInteraction()
    }
    
    func viewWillDisappear() {
        interactor?.stopRecordMic()
        playerPresenter?.setPlayerMuted(false)
        playerPresenter?.enablePlayerInteraction()
        
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
    }
    
    func playerHasLoaded() {
        playerPresenter?.setPlayerMuted(true)
        playerPresenter?.disablePlayerInteraction()
    }
    
    func pushBackButton() {
        wireframe?.removeController()
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func getMicRecorderViewValues() {
        interactor?.getMicRecorderValues()
    }
    
    func startLongPress() {
        startRecord()
    }
    
    func pauseLongPress() {
        pauseRecord()
    }
    
    func startRecord() {
        delegate?.setMicRecorderButtonState(true)
        playerPresenter?.pushPlayButton()
        
        interactor?.startRecordMic()
        
        delegate?.showAcceptCancelButton()
    }
    
    func pauseRecord() {
        delegate?.setMicRecorderButtonState(false)
        playerPresenter?.pushPlayButton()
        
        interactor?.pauseRecordMic()
    }
    
    func acceptMicRecord() {
        interactor?.stopRecordMic()
        
        delegate?.showMixAudioView()
        
        playerPresenter?.enablePlayerInteraction()
        playerPresenter?.setPlayerMuted(false)
    }
    
    func cancelMicRecord() {
        interactor?.stopRecordMic()
        
        playerPresenter?.seekToTime(0.0)
        resetRecord()
    }
    
    func resetRecord() {
        interactor?.initAudioSession()
        
        delegate?.hideAcceptCancelButton()
        delegate?.setMicRecorderButtonState(true)
        delegate?.setMicRecorderButtonEnabled(true)
    }
    
    func updateActualTime(time: Float) {
        recordMicViewActualTime = Double(time) * recordMicViewTotalTime
        if time != 1.0 {
            delegate?.updateRecordMicActualTime("\(hourToString(recordMicViewActualTime))")
        }else{
            delegate?.setMicRecorderButtonEnabled(false)
            playerPresenter?.pauseVideo()
        }
    }
    
    func hourToString(time:Double) -> String {
        let mins = Int(floor(time % 3600) / 60)
        let secs = Int(floor(time % 3600) % 60)
        
        return String(format:"%02d:%02d", mins, secs)
    }
    
    //MARK: - Interactor delegate
    func setVideoComposition(composition: AVMutableComposition) {
        playerPresenter?.createVideoPlayer(composition)
        
    }
    
    func setMicRecorderValues(value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange
        
        delegate?.showMicRecordView(value)
    }
}