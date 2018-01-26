//
//  RecorderInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public protocol RecorderInteractorInterface {
    func getNumberOfClipsInProject() -> Int
    func getLastVideoURL() -> URL
    func clearProject()
    func getProject() -> Project
    func getResolution() -> String
    func saveResolution(resolution: String)
}

public protocol RecorderInteractorDelegate {}
