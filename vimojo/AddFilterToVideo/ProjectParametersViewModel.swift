//
//  ProjectParametersViewModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 15/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

struct ProjectParametersViewModel {
    var brightness:Float = 50
    var contrast:Float = 50
    var exposure:Float = 50
    var saturation:Float = 50
    var filterSelectedPosition:Int?
    
    init(brightness:Float,
         contrast:Float,
         exposure:Float,
         saturation:Float,
         filterSelectedPosition:Int?) {
        
        self.brightness = brightness * 100
        self.contrast = contrast * 100
        self.exposure = exposure * 100
        self.saturation = saturation * 100
        self.filterSelectedPosition = filterSelectedPosition
    }
}
