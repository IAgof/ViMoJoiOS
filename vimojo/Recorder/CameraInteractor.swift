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

class CameraInteractor: NSObject, CameraInteractorInterface {
	var outputURL: URL
	var clipsArray: [String] = []
	var movieOutput: AVCaptureMovieFileOutput
	var activeInput: AVCaptureDeviceInput
    var delegate: RecordPresenter
	var project: Project?
	
    required init(delegate: RecordPresenter,
                  parameters: RecorderParameters,
				  project: Project) {
        self.delegate = delegate
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
    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }
    func getNewClipPath(_ title: String) -> String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
    }
    func getVideoLenght(_ url: URL) -> Double {
        let asset = AVAsset.init(url: url)
        return asset.duration.seconds
    }
}

extension CameraInteractor: AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureFileOutputRecordingDelegate {
    
	//TODO: make it rain
	func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        let title = self.getNewTitle()
        let clipPath = self.getNewClipPath("\(title)")
        self.clipsArray.append(clipPath)
		AddVideoToProjectUseCase().add(videoPath: clipPath,
                                       title: title,
                                       project: self.project!)
	}
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		if (error != nil) {
			fatalError("el video se ha roto!! \n didFinishRecordingTo \(error?.localizedDescription)")
		}
	}
	
	func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
		if (error != nil) {
			fatalError("el video se ha roto!! \n didFinishRecordingToOutputFileAt \(error?.localizedDescription)")
		}
		DispatchQueue.global().async {
			guard let actualProject = self.project else {return}
			ClipsAlbum.sharedInstance.saveVideo(outputFileURL, project: actualProject, completion: {
				saved, videoURL in
				if saved, let videoURLAssets = videoURL {
					self.delegate.trackVideoRecorded(self.getVideoLenght(outputFileURL))
					self.delegate.updateThumbnail(videoURL: videoURLAssets)
					self.delegate.allowRecord()
				}
			})
		}
    }
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
