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
    
    func setIsRecording(isRecording:Bool)
    func startRecordVideo(completion:(String)->Void)
    func rotateCamera()
    
    func changeBlendImage(image:UIImage)
    func changeFilter(newFilter:GPUImageFilter)
    func removeFilters()
    func removeOverlay()
    func removeShaders()
    
    func stopCamera()
    func startCamera()
}

protocol CameraInteractorDelegate {
    func trackVideoRecorded(videoLenght:Double)
    func flashOn()
    func flashOff()
    func cameraFront()
    func cameraRear()
    func showFocus(center:CGPoint)
    func updateThumbnail()
}


