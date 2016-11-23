//
//  ApplyTextOverlayToVideoCompositionUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaPlayer
import VideonaProject

class ApplyTextOverlayToVideoCompositionUseCase:NSObject {
    var project:Project
    
    init(project:Project){
        self.project = project
    }
        
    func applyVideoOverlayAnimation(_ composition:AVMutableVideoComposition,
                                    mutableComposition:AVMutableComposition,
                                    size:CGSize){
        
        print("vodeo size: \(size)")
        let videoFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let videoLayer = CALayer()
        videoLayer.frame = videoFrame
        videoLayer.masksToBounds = true
        videoLayer.contentsScale = UIScreen.main.scale
        
        let layers = generateTextLayers(videoFrame)
        
        let parentLayer = CALayer()
        parentLayer.frame = videoFrame
        parentLayer.addSublayer(videoLayer)
        
        for layer in layers{
            parentLayer.addSublayer(layer)
        }
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    func generateTextLayers(_ overlayFrame:CGRect)->[CALayer]{
        var layers :[CALayer] = []
        
        var timeToInsertAnimate = 0.0
        let videos = project.getVideoList()
        
        for video in videos{
            guard let textPosition =  CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else {
                print("Not valid position")
                return []}
            
            let image = GetImageByTextUseCase().getTextImage(text: video.textToVideo,
                                                             attributes:CATextLayerAttributes().getAlignmentAttributesByType(type: textPosition))

            let textImageLayer = CALayer()
            textImageLayer.contents = image.cgImage
            textImageLayer.frame = overlayFrame
            textImageLayer.contentsScale = UIScreen.main.scale
            textImageLayer.opacity = 0.0
            
            addAnimationToLayer(textImageLayer,
                                timeAt: timeToInsertAnimate,
                                duration: video.getDuration())
            
            layers.append(textImageLayer)
            
            timeToInsertAnimate += video.getDuration()
        }
        
        return layers
    }
    
    func addAnimationToLayer(_ overlay:CALayer,
                             timeAt:Double,
                             duration:Double){
        //Animacion de entrada
        let animationEntrada = CAKeyframeAnimation(keyPath:"opacity")
        animationEntrada.beginTime = AVCoreAnimationBeginTimeAtZero + timeAt
        animationEntrada.duration = duration
        animationEntrada.keyTimes = [0, 0.01, 0.99, 1]
        animationEntrada.values = [0.0, 1.0, 1.0, 0.0]
        animationEntrada.isRemovedOnCompletion = false
        animationEntrada.fillMode = kCAFillModeForwards
        overlay.add(animationEntrada, forKey:"animateOpacity")
    }
}
