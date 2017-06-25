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
    
    var audios: [Audio]{
        guard let project = project else{ return [] }
        var audiosAvailable: [Audio] = []
        
        if !project.getVideoList().isEmpty { audiosAvailable.append(Audio(title: "ProjectAudio", mediaPath: "", musicResource: .originalAudio)) }
        if let music = project.music { audiosAvailable.append(music) }
        
        return audiosAvailable
    }
}
