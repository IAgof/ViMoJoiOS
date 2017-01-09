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
import VideonaProject

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
    var isPlayingMedia = false
    var videoVolume:Float = 1.0
    var audioVolume:Float = 1.0
    
    enum MicViewShowed {
        case micRecord
        case audioMix
    }
    
    var viewShowing:MicViewShowed = .micRecord
    
    //MARK: - Constants
    let NO_MUSIC_SELECTED = -1
    
    //MARK: - Interface
    func viewDidLoad() {
        wireframe?.presentPlayerInterface()

        interactor?.removeVoiceOverFromProject()

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

    }
    
    func playerHasLoaded() {
        playerPresenter?.setPlayerMuted(true)
        playerPresenter?.disablePlayerInteraction()
    }
    
    func pushBackButton() {
        playerPresenter?.setPlayerMuted(false)
        playerPresenter?.enablePlayerInteraction()
        
        playerPresenter?.pauseVideo()
        delegate?.pauseAudioPlayer()
        
        delegate?.removeAudioPlayer()
        
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
        interactor?.stopRecordMic()

        wireframe?.removeController()
    }
    
    func cancelPushed() {
        guard let title = interactor?.getStringByKey(MicRecorderConstants.DISCARD_RECORDER_TITLE) else{return}
        guard let message = interactor?.getStringByKey(MicRecorderConstants.DISCARD_RECORDER_MESSAGE)else{return}
        guard let yes = interactor?.getStringByKey(MicRecorderConstants.YES_ACTION)
            else{return}
        
        delegate?.showAlertDiscardRecord(title,
                                         message: message,
                                         yesString: yes)
    }
    
    func cancelConfirmed() {
        switch viewShowing {
        case .micRecord:
            cancelMicRecord()
            break
        case .audioMix:
            cancelMixAudio()
            break
        }
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
        viewShowing = .audioMix
        
        interactor?.getActualAudioRecorded()
        
        playerPresenter?.enablePlayerInteraction()
        playerPresenter?.setPlayerMuted(false)
        playerPresenter?.seekToTime(0.0)
    }
    
    func cancelMicRecord() {
        interactor?.stopRecordMic()
        
        delegate?.removeAudioPlayer()
        
        playerPresenter?.seekToTime(0.0)
        resetRecord()
    }
    
    func resetRecord() {
        
        playerPresenter?.pauseVideo()
        delegate?.pauseAudioPlayer()
        
        delegate?.seekAudioPlayerTo(0.0)
        playerPresenter?.seekToTime(0.0)
        
        interactor?.initAudioSession()
        
        playerPresenter?.setPlayerMuted(true)
        playerPresenter?.disablePlayerInteraction()
        
        delegate?.hideAcceptCancelButton()
        delegate?.setMicRecorderButtonState(true)
        delegate?.setMicRecorderButtonEnabled(true)
    }
    
    func updateActualTime(_ time: Float) {
        recordMicViewActualTime = Double(time) * recordMicViewTotalTime
        if time != 1.0 {
            delegate?.updateRecordMicActualTime("\(hourToString(recordMicViewActualTime))")
        }else{
            delegate?.setMicRecorderButtonEnabled(false)
            playerPresenter?.pauseVideo()
            delegate?.pauseAudioPlayer()
        }
    }
    
    func hourToString(_ time:Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
        return String(format:"%02d:%02d", mins, secs)
    }
    
    func acceptMixAudio() {
        interactor?.setVoiceOverToProject(videoVolume,audioVolume: audioVolume)
        resetAudioParams()

        wireframe?.presentEditor()
    }
    
    func cancelMixAudio() {
        delegate?.hideMixAudioView()
        viewShowing = .micRecord
        
        delegate?.removeAudioPlayer()
        
        resetRecord()
        resetAudioParams()
        
        interactor?.removeVoiceOverFromProject()
        
        interactor?.getMicRecorderValues()
    }

    func resetAudioParams(){
        videoVolume = 1
        audioVolume = 1
    }
    
    func videoPlayerPlay() {
        isPlayingMedia = true
        
        delegate?.playAudioPlayer()
    }
    
    func videoPlayerPause() {
        isPlayingMedia = false
        
        delegate?.pauseAudioPlayer()
    }
    
    func videoPlayerSeeksTo(_ value: Float) {
        delegate?.seekAudioPlayerTo(value)
        
        if isPlayingMedia{
            delegate?.playAudioPlayer()
        }
    }
    
    func mixVolumeUpdate(_ value: Float) {
        videoVolume = 2 * value
        if videoVolume >= 1 {
            videoVolume = 1
        }
        audioVolume = 2 * ( 1 - value)
        if audioVolume >= 1 {
            audioVolume = 1
        }
        
        print("Slider value = \(value)")
        print("Audio Volume = \(audioVolume)")
        print("Video Volume = \(videoVolume)")
        
        delegate?.changeAudioPlayerVolume(audioVolume)
        
        playerPresenter?.setPlayerVolume(videoVolume)
    }
    
    //MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setMicRecorderValues(_ value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange
        
        delegate?.showMicRecordView(value)
    }
    
    func setActualAudioRecorded(_ url: URL) {
        delegate?.createAudioPlayer(url)
    }
}
