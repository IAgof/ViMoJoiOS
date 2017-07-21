//
//  Audio4VideoPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

protocol Audio4VideoPresenterInterface {
    var sliderValue: Float{ get set}
    func viewDidLoad()
    
    func updatePlayerLayer()
    func cancel()
    func accept()
}

protocol Audio4VideoInteractorDelegate {
    func setVideoComposition(_ composition: VideoComposition)
    func updateAudioMix(audioMix: AVAudioMix)
}

class Audio4VideoPresenter: Audio4VideoPresenterInterface{
    var delegate: Audio4VideoPresenterDelegate?
    var interactor: Audio4VideoInteractorInterface?
    var playerPresenter: PlayerPresenterInterface?
    var wireframe: Audio4VideoWireframe?
    
    var sliderValue: Float = 0{
        didSet{
            interactor?.audioValue = sliderValue
        }
    }
    
    func setup(delegate: Audio4VideoPresenterDelegate, interactor: Audio4VideoInteractorInterface, playerPresenter: PlayerPresenterInterface) {
        self.delegate = delegate
        self.interactor = interactor
        self.playerPresenter = playerPresenter
    }
    
    func viewDidLoad() {
        wireframe?.presentPlayerInterface()
        if let sliderValue = interactor?.initialAudio { delegate?.setupSlider(sliderValue) }
        interactor?.getVideoComposition()
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func cancel() {
        interactor?.resetAudio()
        wireframe?.dissmiss()
    }
    
    func accept() {
        wireframe?.dissmiss()
    }
}

extension Audio4VideoPresenter: Audio4VideoInteractorDelegate{
    //MARK: - Interactor delegate
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func updateAudioMix(audioMix: AVAudioMix) {
        playerPresenter?.setAudioMix(audioMix: audioMix)
    }
}
