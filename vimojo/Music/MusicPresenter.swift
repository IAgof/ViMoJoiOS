//
//  MusicPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer
import AVFoundation

class MusicPresenter: MusicPresenterInterface,MusicInteractorDelegate {
    //MARK: - Variables VIPER
    var controller: MusicViewInterface? //O tengo referencia a uno u a otro, pero no a los dos
    var delegate:MusicPresenterDelegate?
    var interactor: MusicInteractorInterface?
    var wireframe: MusicWireframe?
    
    var detailEventHandler: MusicDetailInterface?
    
    var playerPresenter: PlayerPresenterInterface?
    var playerWireframe: PlayerWireframe?
    
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

    }
    
    func viewWillAppear() {
        controller?.bringToFrontExpandPlayerButton()
    }
    
    func viewDidAppear() {
        self.checkIfHasMusicSelected()
    }
    
    func checkIfHasMusicSelected(){
        if (interactor?.hasMusicSelectedInProject())! {
            guard let music = interactor?.getMusic() else {return}
            
            detailEventHandler?.showRemoveButton()
        }
    }
    
    func viewWillDisappear() {
        interactor?.stopRecordMic()
        
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
        
        if !isMusicSet {
            interactor?.setMusicToProject(NO_MUSIC_SELECTED)
        }
    }
    
    func setMusicDetailInterface(eventHandler: MusicDetailInterface) {
        self.detailEventHandler = eventHandler
    }
    
    func didSelectMusicAtIndexPath(indexPath: NSIndexPath) {
        lastMusicSelected = indexPath.item
        
        delegate?.hideTableView()
        
        interactor?.getMusicDetailParams(lastMusicSelected)

        interactor?.setMusicToProject(lastMusicSelected)
        
        playerPresenter?.createVideoPlayer(GetActualProjectAVCompositionUseCase.sharedInstance.getComposition((interactor?.getProject())!))
    }
    
    func cancelDetailButtonPushed() {
        self.removeDetailButtonPushed()
    }
    
    func acceptDetailButtonPushed() {
        detailEventHandler?.showRemoveButton()
        isMusicSet = true
        
        ViMoJoTracker.sharedInstance.trackMusicSet()
        
        wireframe?.presentEditor()
    }
    
    func removeDetailButtonPushed() {
        delegate?.hideDetailView()
        
        interactor?.setMusicToProject(NO_MUSIC_SELECTED)
        
        playerPresenter?.createVideoPlayer(GetActualProjectAVCompositionUseCase.sharedInstance.getComposition((interactor?.getProject())!))
        
        isMusicSet = false
        
        ViMoJoTracker.sharedInstance.trackMusicSet()
    }
    
    func expandPlayer() {
        wireframe?.presentExpandPlayer()
        
        isGoingToExpandPlayer = true
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    
    func pushMusicHandler() {
        wireframe?.presenterMusicListView()
    }
    
    func pushMicHandler() {
        interactor?.getMicRecorderValues()
    }
    
    func getMusicList(){
        interactor?.getMusicList()
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
        
        delegate?.showMicRecorderAcceptCancelButton()
    }
    
    func pauseRecord() {
        delegate?.setMicRecorderButtonState(false)
        playerPresenter?.pushPlayButton()

        interactor?.pauseRecordMic()
    }
    
    func acceptMicRecord() {
        interactor?.stopRecordMic()
    }
    
    func cancelMicRecord() {
        interactor?.stopRecordMic()
        
        playerPresenter?.seekToTime(0.0)
        delegate?.hideMicRecordView()
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
    func setMusicModelList(list: [MusicViewModel]) {
        delegate?.setMusicList(list)
    }
    
    func setMusicDetailParams(title: String, author: String, image: UIImage) {
        delegate?.showDetailView(title, author: author, image: image)
    }
    
    func setVideoComposition(composition: AVMutableComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setMicRecorderValues(value: MicRecorderViewModel) {
        recordMicViewTotalTime = value.sliderRange
        
        delegate?.showMicRecordView(value)
    }
}