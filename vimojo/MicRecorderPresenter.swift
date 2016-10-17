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
        case MicRecord
        case AudioMix
    }
    
    var viewShowing:MicViewShowed = .MicRecord
    
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
        case .MicRecord:
            cancelMicRecord()
            break
        case .AudioMix:
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
        viewShowing = .AudioMix
        
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
        playerPresenter?.seekToTime(0.0)
        
        interactor?.initAudioSession()
        
        playerPresenter?.setPlayerMuted(true)
        playerPresenter?.disablePlayerInteraction()

        
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
    
    func acceptMixAudio() {
        interactor?.setVoiceOverToProject(videoVolume,audioVolume: audioVolume)
        
        wireframe?.presentEditor()
    }
    
    func cancelMixAudio() {
        delegate?.hideMixAudioView()
        viewShowing = .MicRecord
        
        delegate?.removeAudioPlayer()
        
        resetRecord()
        
        interactor?.removeVoiceOverFromProject()
        
        interactor?.getMicRecorderValues()
    }

    func videoPlayerPlay() {
        isPlayingMedia = true
        
        delegate?.playAudioPlayer()
    }
    
    func videoPlayerPause() {
        isPlayingMedia = false
        
        delegate?.pauseAudioPlayer()
    }
    
    func videoPlayerSeeksTo(value: Float) {
        delegate?.seekAudioPlayerTo(value)
        
        if isPlayingMedia{
            delegate?.playAudioPlayer()
        }
    }
    
    func mixVolumeUpdate(value: Float) {
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
    func setVideoComposition(composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setMicRecorderValues(value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange
        
        delegate?.showMicRecordView(value)
    }
    
    func setActualAudioRecorded(url: NSURL) {
        delegate?.createAudioPlayer(url)
    }
}