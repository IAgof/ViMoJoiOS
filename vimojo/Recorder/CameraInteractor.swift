//
//  CameraInteractor.swift
//  vimojo
//
//  Created by Jesus Huerta on 09/11/2017.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit
import AVFoundation
import VideonaProject

enum VideoResponse {
	case error(Error)
	case success(URL)
}
class CameraInteractor: NSObject, CameraInteractorInterface {
	var outputURL: URL
	var clipsArray: [String] = []
	var movieOutput: AVCaptureMovieFileOutput
	var activeInput: AVCaptureDeviceInput
	var delegate: CameraInteractorDelegate!
	var project: Project?
	
	required init(parameters: RecorderParameters,
				  project: Project) {
		self.project = project
		self.movieOutput = parameters.movieOutput
		self.activeInput = parameters.activeInput
		self.outputURL = parameters.outputURL
	}
	
	public func startRecording(_ completion:@escaping (String) -> Void) {
		let connection = movieOutput.connection(withMediaType: AVMediaTypeVideo)
		if (connection?.isVideoStabilizationSupported)! {
			connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
		}
		if (connection?.isVideoOrientationSupported)! {
			connection?.videoOrientation = activeInput.device.currentVideoOrientation
		}
		let device = activeInput.device
		if (device?.isSmoothAutoFocusSupported)! {
			do {
				try device?.lockForConfiguration()
				device?.isSmoothAutoFocusEnabled = false
				device?.unlockForConfiguration()
			} catch {
				print("Error setting configuration: \(error)")
			}
		}
		movieOutput.startRecording(toOutputFileURL: outputURL, recordingDelegate: self)
		completion("record started in the URL \(outputURL)")
	}
	public func stopRecording() {
		if movieOutput.isRecording == true {
			movieOutput.stopRecording()
		}
	}
}

extension CameraInteractor: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
	//TODO: make it rain
	func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
		print("Start capture didStartRecordingToOutputFileAt with fileURL \n\(fileURL)")
	}
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		print("fileOutput didFinishRecordingTo with fileURL \n\(outputFileURL)")
		
		guard let actualProject = self.project else {return}
		
		ClipsAlbum.sharedInstance.saveVideo(outputFileURL, project: actualProject, completion: {
			saved, videoURL in
			if saved, let videoURLAssets = videoURL {}
		})
		
		let response: VideoResponse!
		if let hasError = error { response = .error(hasError) }
		else { response = .success(outputFileURL) }
		delegate.recordStopped(with: response)
	}
	
	func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) { }
}

extension AVCaptureDevice {
	var currentVideoOrientation: AVCaptureVideoOrientation {
		switch UIDevice.current.orientation {
		case .portrait: return AVCaptureVideoOrientation.portrait
		case .landscapeRight: return  AVCaptureVideoOrientation.landscapeLeft
		case .portraitUpsideDown: return AVCaptureVideoOrientation.portraitUpsideDown
		default: return AVCaptureVideoOrientation.landscapeRight
		}
	}
}
