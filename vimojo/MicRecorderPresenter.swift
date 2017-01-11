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
import VideonaTrackOverView

class MicRecorderPresenter: MicRecorderPresenterInterface {
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
    var micRecordedTimeRangeValues:[CMTimeRange] = []
    var videoTotalTime:Double = 0

    //MARK: - Constants
    let NO_MUSIC_SELECTED = -1
    
    //MARK: - Interface
    func viewDidLoad() {
        wireframe?.presentPlayerInterface()

        interactor?.getVideoComposition()
        interactor?.getMicRecorderValues()
    }
    
    func viewWillAppear() {
        interactor?.loadVoiceOverAudios()
    }
    
    func viewDidAppear() {
        playerPresenter?.disablePlayerInteraction()
    }
    
    func viewWillDisappear() {
        resetRecord()
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

    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func getMicRecorderViewValues() {
        interactor?.getMicRecorderValues()
    }
    
    func startLongPress(atTime: CMTime) {
        startRecord(atTime: atTime)
    }
    
    func pauseLongPress() {
        pauseRecord()
    }
    
    func startRecord(atTime:CMTime) {
        delegate?.setMicRecorderButtonState(true)
        playerPresenter?.pushPlayButton()
        
        interactor?.startRecordMic(atTime: atTime)
        
        delegate?.showAcceptCancelButton()
    }
    
    func pauseRecord() {
        delegate?.setMicRecorderButtonState(false)
        playerPresenter?.pushPlayButton()
        
        interactor?.stopRecordMic()
    }
    
    func acceptMicRecord() {

        interactor?.getActualAudioRecorded()
        
        playerPresenter?.enablePlayerInteraction()
        playerPresenter?.setPlayerMuted(false)
        playerPresenter?.seekToTime(0.0)
    }
    
    func cancelMicRecord() {
        interactor?.removeVoiceOverFromProject()
        
        delegate?.removeAudioPlayer()
        
        playerPresenter?.seekToTime(0.0)
        resetRecord()
    }
    
    func resetRecord() {
        
        playerPresenter?.pauseVideo()
        delegate?.pauseAudioPlayer()
        
        delegate?.seekAudioPlayerTo(0.0)
        playerPresenter?.seekToTime(0.0)
        
        playerPresenter?.setPlayerMuted(true)
        playerPresenter?.disablePlayerInteraction()
        
        delegate?.hideAcceptCancelButton()
        delegate?.setMicRecorderButtonState(true)
        delegate?.setMicRecorderButtonEnabled(true)
        
        for i in (micRecordedTimeRangeValues.count)...0{
            delegate?.removeTrackArea(inPosition: i)
        }
        
        micRecordedTimeRangeValues = []
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
        
        if isPlayingMedia{
            DispatchQueue.main.async {
                self.updateLastAudioTrackAreaWithValue(time: time)
            }
        }
    }
    
    func updateLastAudioTrackAreaWithValue(time: Float){
        if var micRecordedValue = micRecordedTimeRangeValues.last{

            let position = micRecordedTimeRangeValues.count - 1
            let barColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4901541096)
            
            let maxTime = Float(videoTotalTime)
            let lowerValue = Float(micRecordedValue.start.seconds)

            let trackModel = TrackModel(maxValue: maxTime,
                                        lowerValue: lowerValue,
                                        upperValue: time,
                                        color: barColor.cgColor)
            debugPrint(trackModel)

            delegate?.updateRecordedTrackArea(position: position,
                                  value: trackModel)
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
        
        delegate?.changeAudioPlayerVolume(audioVolume)
        
        playerPresenter?.setPlayerVolume(videoVolume)
    }
    
    func micInserctionPointValue(value: Float) {
        playerPresenter?.seekToTime(value)
    }    
}

extension MicRecorderPresenter:MicRecorderInteractorDelegate{
    //MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        if let duration = composition.mutableComposition?.duration.seconds{
            videoTotalTime = duration
        }
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setMicRecorderValues(_ value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange
        
        delegate?.setUpValues(value)
    }
    
    func setActualAudioRecorded(_ voiceOverComposition:AVMutableComposition){
        delegate?.createAudioPlayer(voiceOverComposition)
    }
    
    func setMicRecordedTimeRangeValue(micRecordedRange: CMTimeRange) {
        self.micRecordedTimeRangeValues.append(micRecordedRange)
        
        let barColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4901541096)
        let trackModel = TrackModel(maxValue: Float(videoTotalTime),
                                    lowerValue: Float(micRecordedRange.start.seconds),
                                    upperValue: Float(micRecordedRange.end.seconds),
                                    color: barColor.cgColor)
        debugPrint(trackModel)
        delegate?.setRecordedTrackArea(value: trackModel)
    }
}
