//
//  CompatibleResolutionsInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

class CompatibleResolutionsInteractor: NSObject {
    
    func getCompatibleResolutions() -> Array<String> {
        var compatibleResolutions = Array<String>()
        
        compatibleResolutions.append(AVCaptureSessionPreset1920x1080)
        compatibleResolutions.append(AVCaptureSessionPreset1280x720)
        compatibleResolutions.append(AVCaptureSessionPreset640x480)

        return compatibleResolutions
    }
}