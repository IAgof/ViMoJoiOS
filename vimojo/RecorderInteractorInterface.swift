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
    func getNumberOfClipsInProject()->Int
    func getMediaPathInPosition(position:Int)->String
    func clearProject()
    func getProject()->Project
    func getResolutionImage(resolution:String)
}

public protocol RecorderInteractorDelegate{
    func resolutionImageFound(image:UIImage)
    func resolutionImagePressedFound(image:UIImage)
}