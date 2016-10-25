//
//  SettingsCameraSettings.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

struct cameraSettings {
    var resolution:String
    var quality:String
    
    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let resolutionSaved = defaults.stringForKey(SettingsConstants().SETTINGS_RESOLUTION)
        
        if (resolutionSaved != nil){
            resolution = AVResolutionParse().parseResolutionToView(resolutionSaved!)
            
        }else{
            resolution = AVResolutionParse().parseResolutionToView(AVCaptureSessionPreset1280x720)
        }
        
        let qualitySaved = defaults.stringForKey(SettingsConstants().SETTINGS_QUALITY)
        if (qualitySaved != nil){
            quality = qualitySaved!
        }else{
            quality = ""
        }
    }
}