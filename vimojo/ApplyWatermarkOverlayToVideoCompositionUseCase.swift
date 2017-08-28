//
//  ApplyWatermarkOverlayToVideoCompositionUseCase.swift
//  vimojo
//
//  Created by Jesús Huerta Arrabal on 28/8/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

class ApplyWatermarkOverlayToVideoCompositionUseCase:NSObject {
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
