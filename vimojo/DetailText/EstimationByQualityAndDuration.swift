//
//  EstimationByQualityAndDuration.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import AVFoundation

struct EstimationByQualityAndDuration {
    var size: Float
    var bitRate: Float

    init(quality: String,
         duration: Double) {
        switch quality {
        case AVCaptureSessionPreset3840x2160:
            bitRate = 9216000
            break
        case AVCaptureSessionPreset1920x1080:
            bitRate = 699000
            break
        case AVCaptureSessionPreset1280x720:
            bitRate = 120000
            break
        default:
            bitRate = 9216000
            break

        }
        size = bitRate * Float(duration)
    }
}
