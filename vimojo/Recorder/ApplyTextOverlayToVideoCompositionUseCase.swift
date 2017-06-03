//
//  ApplyTextOverlayToVideoCompositionUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject
import VideonaProject

class ApplyTextOverlayToVideoCompositionUseCase:NSObject {
    var project:Project
    var videonaComposition: VideoComposition
    
    init(project:Project, videonaComposition: VideoComposition){
        self.project = project
        self.videonaComposition = videonaComposition
    }
        
    func applyVideoOverlayAnimation(){
        guard let size = videonaComposition.videoComposition?.renderSize,
        let composition = videonaComposition.videoComposition else {return}
        
        let videoFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let videoLayer = CALayer()
        videoLayer.frame = videoFrame
        videoLayer.masksToBounds = true
        videoLayer.contentsScale = UIScreen.main.scale
        
        let layer = GetActualProjectTextCALayerAnimationUseCase(videonaComposition: videonaComposition).getCALayerAnimation(project: project)
        
        let parentLayer = CALayer()
        parentLayer.frame = videoFrame
        parentLayer.addSublayer(videoLayer)
        
        parentLayer.addSublayer(layer)
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    func generateTextLayers(_ overlayFrame:CGRect)->[CALayer]{
        var layers :[CALayer] = []
        
        let videos = project.getVideoList()
        
        for video in videos{
            layers = GetActualProjectTextCALayerAnimationUseCase(videonaComposition: videonaComposition).getTextLayersAnimated(videoList: videos)
        }
        
        return layers
    }
}
