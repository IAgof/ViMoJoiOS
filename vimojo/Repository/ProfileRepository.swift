//
//  ProfileRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public protocol ProfileRepository {
    /**
     * Get current profile with video parameters selected by user
     * @return current Profile
     */
    func getCurrentProfile() -> Profile
}
