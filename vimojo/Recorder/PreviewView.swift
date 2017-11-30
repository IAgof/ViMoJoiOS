//
//  PreviewView.swift
//  vimojo
//
//  Created by Jesús Huerta Arrabal on 9/11/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit
import AVFoundation

class PreviewView: UIView {
	let captureSession = AVCaptureSession()
	var previewLayer: AVCaptureVideoPreviewLayer!
	var activeInput: AVCaptureDeviceInput!
	var videoQueue: DispatchQueue { return DispatchQueue.main }
	var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
	var isCameraConfigured: Bool = false

	// MARK: Variables
	var captureSessionPreset = AVCaptureSessionPreset1280x720 {
		didSet{
			if captureSession.canSetSessionPreset(captureSessionPreset)
			{ captureSession.sessionPreset = captureSessionPreset }
		}
	}
	var tempURL: URL? {
		let directory = NSTemporaryDirectory() as NSString
		if directory != "" {
			let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
			return URL(fileURLWithPath: path)
		}
		return nil
	}

	var cameraHasFlash: Bool {
		return activeInput.device.hasTorch
	}

	// MARK: Init
	override init(frame: CGRect) {
		super.init(frame: frame)
		configureCamera()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configureCamera()
	}
	private func configureCamera() {
		if !isCameraConfigured {
			setupRecorder()
			isCameraConfigured = true
		}
	}
	func setupRecorder() {
		setupSession(completion: { (isEnabled) in
			if isEnabled {
				setupPreview()
			}
		})
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		if let connection =  self.previewLayer?.connection  {
			let currentDevice: UIDevice = UIDevice.current
			let orientation: UIDeviceOrientation = currentDevice.orientation
			let previewLayerConnection : AVCaptureConnection = connection
			if previewLayerConnection.isVideoOrientationSupported {
				switch (orientation) {
				case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
					break
				case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
					break
				case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
					break
				default: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
					break
				}
			}
		}
	}
	private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
		layer.videoOrientation = orientation
		previewLayer.frame = self.bounds
	}
	func setupPreview() {
		// Configure previewLayer
		previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
		previewLayer.frame = self.bounds
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		self.layer.addSublayer(previewLayer)
	}
	//MARK:- Setup Camera
	func setupSession(completion: (Bool) -> Void) {
		var sessionIsEnabled = false
		captureSession.beginConfiguration()
		sessionIsEnabled = setupCamera() && setupMic() && setupOutput()
		captureSessionPreset = AVCaptureSessionPresetHigh
		captureSession.commitConfiguration()
		completion(sessionIsEnabled)
	}
	private func setupCamera() -> Bool {
		guard let camera = AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back),
			let input = try? AVCaptureDeviceInput(device: camera) else { return false }
		if captureSession.canAddInput(input) {
			captureSession.addInput(input)
			activeInput = input
		}
		return true
	}
	private func setupMic() -> Bool {
		guard let microphone = AVCaptureDevice.defaultDevice(withDeviceType: .builtInMicrophone, mediaType: AVMediaTypeAudio, position: .unspecified),
			let micInput = try? AVCaptureDeviceInput(device: microphone) else { return false }
		if captureSession.canAddInput(micInput) {
			captureSession.addInput(micInput)
		}
		return true
	}
	func setupOutput() -> Bool {
		// Movie output
		movieOutput.movieFragmentInterval = kCMTimeInvalid
		if captureSession.canAddOutput(movieOutput) {
			captureSession.addOutput(movieOutput)
			return true
		}
		return false
	}
	//MARK:- Camera Session
	public func startSession() {
		if !captureSession.isRunning {
			videoQueue.async {
				self.captureSession.startRunning()
			}
		}
	}
	public func stopSession() {
		if captureSession.isRunning {
			videoQueue.async {
				self.captureSession.stopRunning()
			}
		}
	}
	public func rotateCamera() {
		let input = try? AVCaptureDeviceInput(device: cameraPosition)
		captureSession.removeInput(activeInput)
		if captureSession.canAddInput(input) {
			captureSession.addInput(input)
			activeInput = input
		}
	}
}
extension PreviewView {
	var cameraPosition: AVCaptureDevice {
		switch activeInput.device.position {
		case .back:
			return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .front)
		case .front:
			return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
		default:
			return AVCaptureDevice.defaultDevice(withDeviceType: .builtInWideAngleCamera, mediaType: AVMediaTypeVideo, position: .back)
		}
	}
}
