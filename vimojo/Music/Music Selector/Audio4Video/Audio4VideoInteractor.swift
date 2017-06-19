//
//  Audio4VideoInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

protocol Audio4VideoInteractorInterface {
    var project: Project?{get set}
    var audioValue: Float?{ get set}
    func getVideoComposition()
}

class Audio4VideoInteractor: Audio4VideoInteractorInterface {
    var project: Project?
    var delegate: Audio4VideoInteractorDelegate?
    var video: Video?
    var audioValue: Float?{
        didSet{
            if oldValue != nil, let audioValue = audioValue{
                video?.audioLevel = audioValue
                getVideoComposition()
            }
        }
    }
    
    func setup(delegate: Audio4VideoInteractorDelegate, project: Project, video: Video) {
        self.delegate = delegate
        self.project = project
        self.video = video
    }
    
    func getVideoComposition() {
        guard let project = self.project else{ return }
        var composition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        
        delegate?.setVideoComposition(composition)
    }
}
