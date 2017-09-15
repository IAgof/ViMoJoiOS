//
//  CameraInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 25/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage
import AVFoundation
import AVKit
import VideonaProject

class CameraInteractor: CameraRecorderDelegate,
                    CameraInteractorInterface {
    // MARK: - VIPER
    var cameraDelegate: CameraInteractorDelegate
    var cameraRecorder: CameraRecorderInteractor?

    // MARK: - Camera variables
    var videoCamera: GPUImageVideoCamera
    var filter: GPUImageFilter
    var maskFilterInput: GPUImageFilter
    var maskFilterOutput: GPUImageFilter
    var displayView: GPUImageView
    var sourceImageGPUUIElement: GPUImageUIElement?
    var imageView: UIImageView
    var waterMark: GPUImagePicture = GPUImagePicture()
    var maskFilterToRecord = GPUImageFilter()
    var project: Project?

    var cameraResolution = CameraResolution.init(AVResolution: "")

    var isFrontCamera: Bool = false

    var isRecording: Bool = false {
        didSet {
            if isRecording {
                self.setInputToWriter()
            } else {
                self.stopRecordVideo()
            }
        }
    }

    enum FiltersFlag {
        case noFilters
        case withFilters
    }

    var filtersFlag: FiltersFlag = .noFilters

    // MARK: - Init
    required init(display: GPUImageView,
                  cameraDelegate: CameraInteractorDelegate,
                  project: Project) {
        self.cameraDelegate = cameraDelegate
        self.project = project

        videoCamera = GPUImageVideoCamera(sessionPreset: cameraResolution.rearCameraResolution, cameraPosition: .back)

        videoCamera.frameRate = 25

        videoCamera.outputImageOrientation = .landscapeLeft
        displayView = display
        imageView = UIImageView.init(frame: displayView.frame)

        filter = GPUImageFilter()
        maskFilterInput = GPUImageFilter()
        maskFilterOutput = GPUImageFilter()

        videoCamera.addTarget(filter)

        switch filtersFlag {
        case .noFilters:
            filter.addTarget(maskFilterOutput)

            maskFilterOutput.addTarget(displayView)
            break
        case .withFilters:
            self.addBlendFilterAtInit()
            break
        }

        cameraRecorder = CameraRecorderInteractor(project: project)
        videoCamera.startCapture()

        NotificationCenter.default.addObserver(self, selector: #selector(CameraInteractor.checkOrientation), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }

    func startCamera() {
        videoCamera.startCapture()
    }

    func stopCamera() {
        Utils().debugLog("Stop camera capture")
        videoCamera.stopCapture()
    }

    // MARK: - Orientation
    @objc func checkOrientation() {
        if !isRecording {
            switch UIDevice.current.orientation {
            case .portrait, .portraitUpsideDown:
                print("Check Orientation: \(UIDevice.current.orientation)")
//            case .landscapeLeft:
//                videoCamera.outputImageOrientation = .landscapeRight
//                break
            case .landscapeRight, .landscapeLeft:
                videoCamera.outputImageOrientation = .landscapeRight
                break
            default:
                break
            }
        }
    }

    func rotateCamera() {

        if self.isFrontCamera {
            self.videoCamera.rotateCamera()

            self.isFrontCamera = false
            setResolution()
            cameraDelegate.cameraRear()
            cameraDelegate.resetZoom()
        } else {
            self.isFrontCamera = true
            cameraDelegate.cameraFront()
            self.videoCamera.horizontallyMirrorFrontFacingCamera = true
            if(FlashInteractor().isFlashTurnOn()) {
                cameraDelegate.flashOff()
            }
            cameraDelegate.resetZoom()
            setResolution()
            self.videoCamera.rotateCamera()
        }
    }

    // MARK: - Filters functions
    func addBlendFilterAtInit() {
        let blendFilter = GPUImageAlphaBlendFilter()
        blendFilter.mix = 1
        filter.removeAllTargets()

        let image = UIImage.init(named: "filter_free")
        imageView.image = image

        sourceImageGPUUIElement = GPUImageUIElement(view: imageView)

        filter.addTarget(blendFilter)
        sourceImageGPUUIElement!.addTarget(blendFilter)

        blendFilter.addTarget(maskFilterInput)

        maskFilterInput.addTarget(maskFilterOutput)

        maskFilterOutput.addTarget(displayView)

        filter.frameProcessingCompletionBlock = { filter, time in
            self.sourceImageGPUUIElement!.update()
        }
    }

    func changeBlendImage(_ image: UIImage) {
        imageView.image = image
    }

    func changeFilter(_ newFilter: GPUImageFilter) {
        ChangeFilterInteractor().changeFilter(maskFilterInput, newFilter: newFilter, display: displayView)

        maskFilterOutput = newFilter
        if isRecording {
            setInputToWriter()
        }
    }

    func addFilter(_ newFilter: GPUImageFilter) {
        AddFilterInteractor().addFilter(maskFilterInput, newFilter: newFilter, display: displayView)

        maskFilterOutput = newFilter
    }

    func removeFilters() {
        RemoveFilterInteractor().removeFilter(maskFilterInput, imageView: imageView, display: displayView)

        self.reSetOutputIfIsRecording()
    }

    func removeShaders() {
        RemoveFilterInteractor().removeShader(maskFilterInput, display: displayView)

        self.reSetOutputIfIsRecording()
    }

    func reSetOutputIfIsRecording() {
        maskFilterOutput = GPUImageFilter()

        maskFilterInput.addTarget(maskFilterOutput)

        maskFilterOutput.addTarget(displayView)

        if isRecording {
            setInputToWriter()
        }
    }

    func removeOverlay() {
        RemoveFilterInteractor().removeOverlay(imageView)
    }

    func setInputToWriter() {
        switch filtersFlag {
        case .noFilters:
            maskFilterOutput.addTarget(maskFilterToRecord)

            break
        case .withFilters:
            print("set Input To Writer")

            print("\n maskFilterOutput targets \n \(maskFilterOutput.targets())\n\n\n")
            let blendFilter = GPUImageAlphaBlendFilter()
            blendFilter.mix = 1

            let image = UIImage.init(named: "water_mark")

            waterMark = GPUImagePicture.init(image: image)

            maskFilterOutput.addTarget(blendFilter)
            waterMark.addTarget(blendFilter)

            waterMark.processImage()

            maskFilterToRecord = GPUImageFilter()

            blendFilter.addTarget(maskFilterToRecord)
            blendFilter.useNextFrameForImageCapture()
            break
        }

        cameraRecorder?.setInput(maskFilterToRecord)
    }

    // MARK: - Recorder delegate
    func startRecordVideo(_ completion:@escaping (String) -> Void) {
        print("Start record video")

        cameraRecorder?.setVideoCamera(videoCamera)
        cameraRecorder?.setResolution(cameraResolution.rearCameraResolution)

        cameraRecorder?.recordVideo({answer in
            print("Camera Interactor \(answer)")
            completion(answer)
        })
    }

    func stopRecordVideo() {
        for maskFilter in maskFilterOutput.targets() {
            if maskFilter is GPUImageFilter {
                maskFilterOutput.removeTarget(maskFilter as! GPUImageInput)
            }
        }
        cameraRecorder?.stopRecordVideo({duration, videoURL in
            Utils().debugLog("Answer from record interactor:  duration-\(duration)")
            self.cameraDelegate.trackVideoRecorded(duration)
            self.cameraDelegate.updateThumbnail(videoURL: videoURL)
        })
    }

    // MARK: - Event handler
    func setIsRecording(_ isRecording: Bool) {
        self.isRecording = isRecording
    }

    func setResolution() {
        guard let actualProject = project else {return}
        //Get resolution
        cameraResolution = CameraResolution.init(AVResolution: actualProject.getProfile().getResolution())

        //Set resolution
        if isFrontCamera {
            if UIDevice.current.model == "iPhone4,1" {

            } else {
                videoCamera.captureSessionPreset = cameraResolution.frontCameraResolution
            }
        } else {
            videoCamera.captureSessionPreset = cameraResolution.rearCameraResolution
        }
    }
}
