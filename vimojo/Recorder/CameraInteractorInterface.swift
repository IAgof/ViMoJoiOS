//
//  CameraInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

protocol CameraInteractorInterface {
	init(parameters: RecorderParameters,
		 project: Project)
	func startRecording()
	func stopRecording()
//    func setResolution()
//    func setIsRecording(_ isRecording: Bool)
//    func startRecordVideo(_ completion:@escaping (String) -> Void)
//    func rotateCamera()
//    func stopCamera()
//    func startCamera()
}

protocol CameraInteractorDelegate {
	func recordStopped(with response: VideoResponse )
//    func trackVideoRecorded(_ videoLenght: Double)
//    func flashOn()
//    func flashOff()
//    func cameraFront()
//    func cameraRear()
//    func resetZoom()
//    func showFocus(_ center: CGPoint)
//    func updateThumbnail(videoURL: URL?)
}
