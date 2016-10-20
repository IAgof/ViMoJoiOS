//
//  AddTextInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

protocol AddTextInteractorInterface {
    func setVideoPosition(position: Int) 
    func setUpComposition(completion:(VideoComposition)->Void)
    
    func getVideoParams()
    func setParametersToVideo(text:String,
                              position:Int)
    
    func getTextImage(text:String)
    func getAVSyncLayerToPlayer(text: String)
    func setAlignment(alignment:CATextLayerAttributes.VerticalAlignment,
                      text:String)
}

protocol AddTextInteractorDelegate {
    func setVideoParams(text:String,
                        position:Int)
    
    func updateVideoList()
    func setAVSyncLayerToPlayer(layer:CALayer)
}