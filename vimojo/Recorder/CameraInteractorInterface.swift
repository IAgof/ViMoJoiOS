//
//  CameraInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage
import VideonaProject

protocol CameraInteractorInterface {
    init(display:GPUImageView,
         cameraDelegate: CameraInteractorDelegate,
         project:Project)
    func setResolution()
    
    func setIsRecording(_ isRecording:Bool)
    func startRecordVideo(_ completion:@escaping (String)->Void)
    func rotateCamera()
    
    func changeBlendImage(_ image:UIImage)
    func changeFilter(_ newFilter:GPUImageFilter)
    func removeFilters()
    func removeOverlay()
    func removeShaders()
    
    func stopCamera()
    func startCamera()
}

protocol CameraInteractorDelegate {
    func trackVideoRecorded(_ videoLenght:Double)
    func flashOn()
    func flashOff()
    func cameraFront()
    func cameraRear()
    func showFocus(_ center:CGPoint)
    func updateThumbnail(videoURL: URL?)
}


