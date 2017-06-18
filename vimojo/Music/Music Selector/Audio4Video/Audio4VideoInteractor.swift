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
    var project: Project{get set}
    func getVideoComposition()
}

protocol Audio4VideoInteractorDelegate {
    func setVideoComposition(_ composition: VideoComposition)
}

class Audio4VideoInteractor: Audio4VideoInteractorInterface {
    var project: Project?
    var delegate: Audio4VideoInteractorDelegate?
    
    func setup(delegate: Audio4VideoInteractorDelegate, project: Project) {
        self.delegate = delegate
        self.project = project
    }
    
    func getVideoComposition() {
        
    }
}
