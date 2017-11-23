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
	func startRecording(_ completion:@escaping (String) -> Void)
	func stopRecording()
}

protocol CameraInteractorDelegate {
	func trackVideoRecorded(_ videoLenght: Double)
	func updateThumbnail(_ videoURL: URL?)
	func allowRecord()
}
