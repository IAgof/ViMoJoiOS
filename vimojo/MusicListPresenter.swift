//
//  MusicListPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation
import VideonaProject

class MusicListPresenter:MusicListPresenterInterface{
    //MARK: - Variables VIPER
    var delegate:MusicListPresenterDelegate?
    var interactor: MusicListInteractorInterface?
    var wireframe: MusicListWireframe?
    
    var detailEventHandler: MusicDetailInterface?
    
    var playerPresenter: PlayerPresenterInterface?
    
    //MARK: - Variables
    var lastMusicSelected:Int = -1
    var isMusicSet:Bool = false
    var videoVolume:Float = 1.0
    var audioVolume:Float = 1.0
    
    //MARK: - Constants
    let NO_MUSIC_SELECTED = -1
    
    //MARK: - Interface
    func viewDidLoad() {
                
    }
    
    func viewWillAppear() {
        wireframe?.presentPlayerInterface()
        
        interactor?.getVideoComposition()
    }
    
    func viewDidAppear() {
        self.checkIfHasMusicSelected()
    }
    
    func checkIfHasMusicSelected(){
        if (interactor?.hasMusicSelectedInProject())! {
            interactor?.getMusic()
            
            detailEventHandler?.showRemoveButton()
        }else{
            delegate?.showTableView()
        }
    }
    
    func viewWillDisappear() {        
//        if !isGoingToExpandPlayer{
//            playerPresenter?.onVideoStops()
//        }
        
        if !isMusicSet {
            interactor?.setMusicToProject(NO_MUSIC_SELECTED)
        }
        
        lastMusicSelected = NO_MUSIC_SELECTED
    }
    
    func pushBackButton() {
        wireframe?.removeController()
    }
    
    func pushOptions() {
        wireframe?.presentSettings()
    }
    
    func setMusicDetailInterface(_ eventHandler: MusicDetailInterface) {
        self.detailEventHandler = eventHandler
    }
    
    func setMixAudioValue(mixAudioValue value: Float) {
        let mixAudio = MixAudioModel(sliderValue: value,
                                     mixVideoWeight: MusicListConstants.mixAudioWeight)
        
        audioVolume = mixAudio.audioVolume
        videoVolume = mixAudio.videoVolume
        
        debugPrint("setMixAudioValue audioVolume")
        debugPrint(audioVolume)
        debugPrint("setMixAudioValue videoVolume")
        debugPrint(videoVolume)
        
        
        interactor?.updateAudioMix(withParameter: mixAudio)
    }
    
    func didSelectMusicAtIndexPath(_ indexPath: IndexPath) {
        lastMusicSelected = indexPath.item
        
        delegate?.hideTableView()
        
        interactor?.getMusicDetailParams(lastMusicSelected)
        
        interactor?.setMusicToProject(lastMusicSelected)
        
        interactor?.getVideoComposition()        
    }
    
    func cancelDetailButtonPushed() {
        self.removeDetailButtonPushed()
        
        delegate?.showTableView()
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
        
        interactor?.getVideoComposition()
        
        isMusicSet = false
        
        ViMoJoTracker.sharedInstance.trackMusicSet()
        
        delegate?.showTableView()
    }
    
    func expandPlayer() {
//        wireframe?.presentExpandPlayer()
        
//        isGoingToExpandPlayer = true
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    
    func pushMusicHandler() {
        delegate?.showTableView()
    }

    func getMusicList(){
        interactor?.getMusicList()
    }
    
    func playerHasLoaded() {
        if lastMusicSelected != NO_MUSIC_SELECTED{
            playerPresenter?.pushPlayButton()
        }
    }
}

extension MusicListPresenter:MusicListInteractorDelegate{
    //MARK: - Interactor delegate
    func setMusicModelList(_ list: [MusicViewModel]) {
        delegate?.setMusicList(list)
    }
    func setMusicDetailParams(musicDetailViewModel detail: MusicDetailViewModel) {
        delegate?.showDetailView(musicDetailViewModel: detail)
    }
    
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setAudioMix(audioMix value: AVAudioMix) {
        playerPresenter?.setAudioMix(audioMix: value)
    }
}
