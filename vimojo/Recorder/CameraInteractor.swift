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
    var activeInput: AVCaptureDeviceInput
    var project: Project?
    
    var videoWriterInput: AVAssetWriterInput?
    var audioWriterInput: AVAssetWriterInput?
    var videoWriter: AVAssetWriter?
    var dataOutput: AVCaptureVideoDataOutput?
    let audioDataOutput: AVCaptureAudioDataOutput?
    let recordingQueue = DispatchQueue(label: "com.somedomain.recordingQueue")
    
    lazy var lastSampleTime: CMTime = {
        let lastSampleTime = kCMTimeZero
        return lastSampleTime
    }()
    lazy var isRecordingVideo: Bool = {
        let isRecordingVideo = false
        return isRecordingVideo
    }()
    
    required init(delegate: CameraInteractorDelegate,
                  parameters: RecorderParameters,
                  project: Project) {
        self.cameraDelegate = delegate
        self.project = project
        self.dataOutput = parameters.dataOutput
        self.audioDataOutput = parameters.audioDataOutput
        self.activeInput = parameters.activeInput
        self.outputURL = parameters.outputURL
        super.init()
        dataOutput?.setSampleBufferDelegate(self, queue: recordingQueue)
        audioDataOutput?.setSampleBufferDelegate(self, queue: recordingQueue)
    }
    
    fileprivate func setUpAudioWriter(_ videoWriter: AVAssetWriter) {
        let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio,
                                                  outputSettings: AudioSettings.audioSettings)
        audioWriterInput.expectsMediaDataInRealTime = true
        if videoWriter.canAdd(audioWriterInput) {
            videoWriter.add(audioWriterInput)
            self.audioWriterInput = audioWriterInput
        }
    }
    fileprivate func setUpVideoWriter(_ videoWriter: AVAssetWriter) {
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo,
                                                  outputSettings: VideoSettings.videoSettings)
        
        videoWriterInput.expectsMediaDataInRealTime = true
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
            self.videoWriterInput = videoWriterInput
        }
    }
    private func setupWritter(success: () -> Void) {
        do {
            self.videoWriter = try AVAssetWriter(outputURL: outputURL, fileType: AVFileTypeQuickTimeMovie)
        } catch let error as NSError {
            print("ERROR:::::>>>>>>>>>>>>>Cannot init videoWriter, error:\(error.localizedDescription)")
        }
        guard let videoWriter = self.videoWriter else { return }
        setUpVideoWriter(videoWriter)
        setUpAudioWriter(videoWriter)
        self.isRecordingVideo = true
        success()
    }
    fileprivate func saveOnClipsAlbum() {
        ClipsAlbum.sharedInstance.saveVideo(self.outputURL) { (response) in
            switch response {
            case .error(let error): print("do something with this \(error)")
            case .success(let localIdentifier):
                guard let actualProject = self.project else { return }
                let title = self.getNewTitle()
                let clipPath = self.getNewClipPath("\(title)")
                AddVideoToProjectUseCase().add(videoPath: clipPath,
                                               title: title,
                                               project: actualProject)
                self.setVideoUrlParameters(localIdentifier,
                                           project: actualProject)
//                Utils().removeFileFromURL(self.outputURL)
                self.cameraDelegate.allowRecord()
            }
        }
    }
    public func startRecording(_ closure:@escaping () -> Void) {
        if isRecordingVideo == false,
            let connection = dataOutput?.connection(withMediaType: AVMediaTypeVideo) {
            if (connection.isVideoStabilizationSupported) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            if (connection.isVideoOrientationSupported) {
                connection.videoOrientation = activeInput.device.currentVideoOrientation
            }
            setupWritter { closure() }
        }
        else {
            stopRecording()
        }
    }
    public func stopRecording() {
        if isRecordingVideo {
            self.isRecordingVideo = false
            self.videoWriter?.endSession(atSourceTime: lastSampleTime)
            self.videoWriter!.finishWriting {
                if self.videoWriter!.status == AVAssetWriterStatus.completed {
                    self.saveOnClipsAlbum()
                    self.videoWriter = nil
                }
            }
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

extension CameraInteractor: AVCaptureVideoDataOutputSampleBufferDelegate,
    AVCaptureFileOutputRecordingDelegate
    , AVCaptureAudioDataOutputSampleBufferDelegate
{
    func capture(_ output: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        printIsolated(message: "didFinishRecordingToOutputFileAt", object: outputFileURL)
    }
    
    func captureOutput(_ output: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!,
                       from connection: AVCaptureConnection!) {
        guard CMSampleBufferDataIsReady(sampleBuffer),
            isRecordingVideo,
            let videoWriter = self.videoWriter,
            let videoWriterInput = self.videoWriterInput,
            let audioWriterInput = self.audioWriterInput else { return }
        
        lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
        if videoWriter.status != AVAssetWriterStatus.writing {
            videoWriter.startWriting()
            videoWriter.startSession(atSourceTime: lastSampleTime)
        }
        if videoWriter.status == .writing {
            let isVideo = output is AVCaptureVideoDataOutput
            let isAudio = output is AVCaptureAudioDataOutput
            
            if isVideo && videoWriterInput.isReadyForMoreMediaData {
                newVideoSample(sampleBuffer: sampleBuffer)
            } else if isAudio && audioWriterInput.isReadyForMoreMediaData {
                newAudioSample(sampleBuffer: sampleBuffer)
            }
        }
    }
    
    func newVideoSample(sampleBuffer: CMSampleBuffer) {
        if (isRecordingVideo) {
            guard (videoWriter?.status == AVAssetWriterStatus.writing) else { return }
            videoWriterInput?.append(sampleBuffer)
        }
    }
    
    func newAudioSample(sampleBuffer: CMSampleBuffer) {
        if (isRecordingVideo) {
            guard (videoWriter?.status == AVAssetWriterStatus.writing) else { return }
            audioWriterInput?.append(sampleBuffer)
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
