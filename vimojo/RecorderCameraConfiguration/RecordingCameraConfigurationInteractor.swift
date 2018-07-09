//
//  RecordingCameraConfigurationInteractor.swift
//  vimojo
//
//  Created Jesus Huerta on 19/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
typealias RecordingCameraValues = (CameraStatus,
    Resolution,
    FrameRate,
    BitRate)

class RecordingCameraConfigurationInteractor: RecordingCameraConfigurationInteractorInputProtocol {

    weak var presenter: RecordingCameraConfigurationInteractorOutputProtocol?
    
    func loadValues(with camera: CameraPosition, completion: (RecordingCameraValues) -> Void) {
       CamSettings.cameraPosition = camera
        completion((
            CamSettings.cameraStatus,
            VideoSettings.resolution,
            VideoSettings.fps,
            VideoSettings.bitRate))
    }
    func actionPush(with action: RecordingCameraActions){
        switch action {
        case .camera(let camera):
			CamSettings.cameraStatus = camera
        case .resolution(let resolution):
            VideoSettings.resolution = resolution
        case .fps(let fps):
            VideoSettings.fps = fps
        case .mbps(let mbps):
            VideoSettings.bitRate = mbps
        }
    }
}
