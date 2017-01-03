//
//  SettingsCameraSettings.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

struct CameraSettings {
    var resolution:String
    var quality:String
    var frameRate:Int
    
    init(project:Project){
        let defaults = UserDefaults.standard
                
        quality = project.getProfile().getQuality()
        resolution = project.getProfile().getResolution()
        
        var frameRateSaved = defaults.integer(forKey: SettingsConstants().SETTINGS_FRAMERATE)
        
        if(frameRateSaved == 0){
            frameRateSaved = 30
        }
        
        frameRate = frameRateSaved
    }
}
