//
//  MixAudioModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 13/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

struct MixAudioModel {
    var audioVolume:Float = 0
    var videoVolume:Float = 0
    var sliderValue:Float = 0
    
    init(audioVolume:Float,
         videoVolume:Float) {
        self.videoVolume = videoVolume
        self.audioVolume = audioVolume
        
        if videoVolume != 1{
            self.sliderValue = (videoVolume)/2
        }
        
        if audioVolume != 1{
            self.sliderValue = 1 - audioVolume/2
        }
    }
    
    init(sliderValue:Float) {
        self.sliderValue = sliderValue
        
        videoVolume = min(1, 2 * sliderValue)
        audioVolume = min(1,2 * ( 1 - sliderValue))
    }
}
