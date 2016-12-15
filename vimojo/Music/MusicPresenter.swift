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
import VideonaProject

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
    }
    
    func viewWillAppear() {
        wireframe?.presentPlayerInterface()

        controller?.bringToFrontExpandPlayerButton()
        interactor?.getVideoComposition()
    }
    
    func viewDidAppear() {

    }
    
    func viewWillDisappear() {
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
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
        wireframe?.presenterMicRecorderView()
    }
    
    func pushOptions() {
        wireframe?.presentSettings()
    }
    
    //MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
}
