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
            actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project!)
            if actualComposition != nil {
                let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project!)
                actualComposition?.layerAnimation = layer
                delegate?.setVideoComposition(actualComposition!)
            }
        }
    }
}