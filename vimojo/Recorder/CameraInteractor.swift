//
//  CameraInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import AVFoundation
import VideonaProject
import Photos

class CameraInteractor: NSObject, CameraInteractorInterface {
	var cameraDelegate: CameraInteractorDelegate
	var outputURL: URL
	var movieOutput: AVCaptureMovieFileOutput
	var activeInput: AVCaptureDeviceInput
	var project: Project?

	required init(delegate: RecordPresenter,
				  parameters: RecorderParameters,
				  project: Project) {
		self.cameraDelegate = delegate
		self.project = project
		self.movieOutput = parameters.movieOutput
		self.activeInput = parameters.activeInput
		self.outputURL = parameters.outputURL
	}

	public func startRecording(_ closure:@escaping () -> Void) {
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
		closure()
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
	func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {}
	func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
		if let error = error {
			fatalError("el video se ha roto!! \n didFinishRecordingTo \(error.localizedDescription)")
		}
	}

	func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
		if let error = error {
			fatalError("el video se ha roto!! \n didFinishRecordingToOutputFileAt \(error.localizedDescription)")
		}
		ClipsAlbum.sharedInstance.saveVideo(outputFileURL) { (response) in
			switch response {
			case .error(let error): print("do something with this \(error)")
			case .success(let localIdentifier):
				guard let actualProject = self.project else { fatalError("Project is nil! never should be nil") }
				let title = self.getNewTitle()
				let clipPath = self.getNewClipPath("\(title)")
				AddVideoToProjectUseCase().add(videoPath: clipPath,
											   title: title,
											   project: actualProject)
				self.setVideoUrlParameters(localIdentifier,
										   project: actualProject)
				Utils().removeFileFromURL(outputFileURL)
				self.cameraDelegate.allowRecord()
			}
		}
	}
	func setVideoUrlParameters(_ localIdentifier: String, project: Project) {
		if let video = project.getVideoList().last {
			let phFetchAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
			let phAsset = phFetchAsset[0]
			PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil, resultHandler: {
				avasset, _, _ in
				if let asset = avasset as? AVURLAsset {
					video.videoURL = asset.url
					video.mediaRecordedFinished()
					VideoRealmRepository().add(item: video)
					ViMoJoTracker.sharedInstance.sendVideoRecordedTracking(video.getDuration())
					project.updateModificationDate()
					ProjectRealmRepository().update(item: project)
					self.cameraDelegate.trackVideoRecorded(video.getDuration())
					self.cameraDelegate.updateThumbnail(videoURL: asset.url)
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
