//
//  ProfileSharedPreferencesRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class ProfileDefaultsRepository:ProfileRepository{
    let defaults = UserDefaults.standard
    let camera = cameraSettings()

    public func getCurrentProfile() -> Profile {
        return Profile(resolution: camera.resolution,
                       videoQuality: camera.quality,
                       frameRate: camera.frameRate)
    }
}
