//
//  MusicInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject
import AVFoundation

class MusicInteractor: MusicInteractorInterface {
    var delegate:MusicInteractorDelegate?
    var project:Project?
    var actualComposition:VideoComposition?
    
    init() {
        addAudioObservers()
    }
    
    deinit {
        removeAudioObservers()
    }
    
    private func addAudioObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlerAudioUpdate(notification:)), name: Notification.audioUpdate, object: nil)
    }
    
    private func removeAudioObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handlerAudioUpdate(notification: Notification) {
        guard let audio = notification.object as? AudioUpdate, let project = self.project else {return}
        switch audio.musicResource {
        case .originalAudio: project.projectOutputAudioLevel = audio.volume
        case .music: project.music?.audioLevel = audio.volume
        case .voiceOver: project.voiceOver.forEach({ $0.audioLevel = audio.volume })
        default: break
        }
        
        ProjectRealmRepository().update(item: project)
        updateAudioMix()
    }
    
    
    func getVideoComposition() {
        if project != nil{
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project!)
            if let composition = actualComposition{
                let layer = GetActualProjectTextCALayerAnimationUseCase(videonaComposition: composition).getCALayerAnimation(project: project!)
                actualComposition?.layerAnimation = layer
                delegate?.setVideoComposition(actualComposition!)
            }
        }
    }
    
    private func updateAudioMix(){
        if let project = project {
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
            if let audioMix = actualComposition?.audioMix{ delegate?.update(audioMix: audioMix) }
        }
    }
    
    var audios: [Audio]{
        guard let project = project else{ return [] }
        var audiosAvailable: [Audio] = []
        
        if !project.getVideoList().isEmpty { audiosAvailable.append(Audio(title: "ProjectAudio", mediaPath: "", musicResource: .originalAudio)) }
        if let music = project.music { audiosAvailable.append(music) }
        
        return audiosAvailable
    }
}
