//
//  CameraView.swift
//  vimojo
//
//  Created by Jesús Huerta Arrabal on 9/11/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {

    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    var videoQueue: DispatchQueue { return DispatchQueue.main }
    var movieOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    var isCameraConfigured: Bool = false
    
    var captureSessionPreset: AVCaptureSession.Preset = AVCaptureSessionPresetHigh as AVCaptureSession.Preset {
        didSet{
            if captureSession.canSetSessionPreset(captureSessionPreset as String!)
            { captureSession.sessionPreset = captureSessionPreset as String! }
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCamera()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configureCamera() {
        if !isCameraConfigured {
            setupRecorder()
            isCameraConfigured = true
        }
    }
    private func setupRecorder() {
        setupSession(completion: { (isEnabled) in
            if isEnabled {
                setupPreview()
                startSession()
            }
        })
    }
    //    override func layoutSubviews() {
    //        super.layoutSubviews()
    //        if let connection =  self.previewLayer?.connection  {
    //            let currentDevice: UIDevice = UIDevice.current
    //            let orientation: UIDeviceOrientation = currentDevice.orientation
    //            let previewLayerConnection : AVCaptureConnection = connection
    //            if previewLayerConnection.isVideoOrientationSupported {
    //                switch (orientation) {
    //                case .portrait: updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
    //                    break
    //                case .landscapeRight: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
    //                    break
    //                case .landscapeLeft: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
    //                    break
    //                default: updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
    //                    break
    //                }
    //            }
    //        }
    //    }
    private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
        layer.videoOrientation = orientation
        previewLayer.frame = self.bounds
    }
    func setupPreview() {
        // Configure previewLayer
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = true
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer)
    }
    //MARK:- Setup Camera
    private func setupSession(completion: (Bool) -> Void) {
        var sessionIsEnabled = false
        sessionIsEnabled = setupCamera() && setupMic() && setupOutput()
        captureSessionPreset = AVCaptureSessionPresetHigh as AVCaptureSession.Preset
        completion(sessionIsEnabled)
    }
    private func setupCamera() -> Bool {
        let camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) as AVCaptureDevice
        let input = try? AVCaptureDeviceInput(device: camera)
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
            activeInput = input
        }
        return true
    }
    private func setupMic() -> Bool {
        guard let microphone = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeAudio),
            let micInput = try? AVCaptureDeviceInput(device: microphone) else { return false }
        if captureSession.canAddInput(micInput) {
            captureSession.addInput(micInput)
        }
        return true
    }
    private func setupOutput() -> Bool {
        // Movie output
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
}
