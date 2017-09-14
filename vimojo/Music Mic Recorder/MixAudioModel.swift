//
//  MixAudioModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 13/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

struct MixAudioModel {
    var audioVolume: Float = 0
    var videoVolume: Float = 0
    var sliderValue: Float = 0
    private var mixVideoWeight: Float = 0.5

    init(audioVolume: Float,
         videoVolume: Float,
         mixVideoWeight: Float?) {
        self.videoVolume = videoVolume
        self.audioVolume = audioVolume
        if let weight = mixVideoWeight {
            self.mixVideoWeight = weight
        }

        if audioVolume != 1 {
            self.sliderValue = (audioVolume)*self.mixVideoWeight
        }

        if videoVolume != 1 {
            self.sliderValue = 1 - (videoVolume*(1 - self.mixVideoWeight))
        }

        if videoVolume == 1 && audioVolume == 1 {
            self.sliderValue = videoVolume*self.mixVideoWeight
        }
    }

    init(sliderValue: Float,
         mixVideoWeight: Float?) {
        self.sliderValue = sliderValue
        if let weight = mixVideoWeight {
            self.mixVideoWeight = weight
        }

        self.audioVolume = min(1, sliderValue/self.mixVideoWeight)
        self.videoVolume = min(1, (1-sliderValue)/(1-self.mixVideoWeight))
    }
}
