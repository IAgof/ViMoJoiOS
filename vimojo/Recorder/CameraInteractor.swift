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
    
    var videoWriterInput: AVAssetWriterInput?
    var audioWriterInput: AVAssetWriterInput?
    var videoWriter: AVAssetWriter?
    var dataOutput: AVCaptureVideoDataOutput?
    var timeOffset: CMTime = kCMTimeZero
    var lastAudioPts: CMTime? = kCMTimeZero
    
    // audio output
    let audioDataOutput: AVCaptureAudioDataOutput?
    let videoStreamingQueue = DispatchQueue(label: "com.somedomain.videoStreamingQueue")
    let audioStreamingQueue = DispatchQueue(label: "com.somedomain.audioStreamingQueue")
    
    lazy var lastSampleTime: CMTime = {
        let lastSampleTime = kCMTimeZero
        return lastSampleTime
    }()
    lazy var isRecordingVideo: Bool = {
        let isRecordingVideo = false
        return isRecordingVideo
    }()
    lazy var frameCount: Int64 = {
        return 0
    }()
    
    required init(delegate: CameraInteractorDelegate,
                  parameters: RecorderParameters,
                  project: Project) {
        self.cameraDelegate = delegate
        self.project = project
        self.movieOutput = parameters.movieOutput
        self.dataOutput = parameters.dataOutput
        self.audioDataOutput = parameters.audioDataOutput
        self.activeInput = parameters.activeInput
        self.outputURL = parameters.outputURL
        super.init()
        dataOutput?.setSampleBufferDelegate(self, queue: videoStreamingQueue)
        audioDataOutput?.setSampleBufferDelegate(self, queue: audioStreamingQueue)
    }
    
    fileprivate func setUpAudioWriter(_ videoWriter: AVAssetWriter) {
        // AUDIO
        let audioOutputSettings: Dictionary<String, Any> = [
            AVFormatIDKey : kAudioFormatMPEG4AAC,
            AVNumberOfChannelsKey : NSNumber(value: 1),
            AVSampleRateKey : NSNumber(value: 44100.0),
            AVEncoderBitRateKey : NSNumber(value: 64000)
        ]
        let audioWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeAudio,
                                                  outputSettings: audioOutputSettings)
        audioWriterInput.expectsMediaDataInRealTime = true
        if videoWriter.canAdd(audioWriterInput) {
            videoWriter.add(audioWriterInput)
            self.audioWriterInput = audioWriterInput
        } else {
            fatalError("ERROR:::Cannot add videoWriterInput into videoWriter")
        }
    }
    
    fileprivate func setUpVideoWriter(_ videoWriter: AVAssetWriter) {
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: 1080,
            AVVideoHeightKey: 720
        ]
        let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo,
                                                  outputSettings: videoSettings)
        self.videoWriterInput = videoWriterInput
        videoWriterInput.expectsMediaDataInRealTime = true
        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        } else {
            fatalError("ERROR:::Cannot add videoWriterInput into videoWriter")
        }
    }
    
    private func setupWritter() {
        do {
            self.videoWriter = try AVAssetWriter(outputURL: outputURL, fileType: AVFileTypeQuickTimeMovie)
        } catch let error as NSError {
            print("ERROR:::::>>>>>>>>>>>>>Cannot init videoWriter, error:\(error.localizedDescription)")
        }
        guard let videoWriter = self.videoWriter else { fatalError("video writter is nil") }
        setUpVideoWriter(videoWriter)
        setUpAudioWriter(videoWriter)
        self.isRecordingVideo = true
    }
    
    func finishRecord() {
        self.isRecordingVideo = false
        self.videoWriter!.finishWriting {
            if self.videoWriter!.status == AVAssetWriterStatus.completed {
                ClipsAlbum.sharedInstance.saveVideo(self.outputURL) { (response) in
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
                        Utils().removeFileFromURL(self.outputURL)
                        self.cameraDelegate.allowRecord()
                    }
                }
            } else {
                print("WARN:::The videoWriter status is not completed, stauts: \(self.videoWriter!.status)")
            }
        }
    }
    
    fileprivate func addMetaData() {
        var metadata: [Any] = (movieOutput.metadata != nil) ? movieOutput.metadata:Array<Any>()
        
        let orientationItem =  AVMutableMetadataItem()
        orientationItem.identifier = AVMetadataIdentifierQuickTimeMetadataVideoOrientation
        let orientation: NSNumber = RecordController.isFrontCamera ? 180:0
        orientationItem.value =  orientation as NSCopying & NSObjectProtocol
        metadata.append(orientationItem)
        movieOutput.metadata = metadata
    }
    
    public func startRecording(_ closure:@escaping () -> Void) {
        self.timeOffset = CMTimeMake(0, 0)
        
        if isRecordingVideo == false,
            let connection = dataOutput?.connection(withMediaType: AVMediaTypeVideo) {
            if (connection.isVideoStabilizationSupported) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            if (connection.isVideoOrientationSupported) {
                connection.videoOrientation = activeInput.device.currentVideoOrientation
            }
            setupWritter()
            //            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            closure()
        }
        else {
            stopRecording()
        }
    }
    public func stopRecording() {
        finishRecord()
        //        if movieOutput.isRecording == true {
        //            movieOutput.stopRecording()
        //        }
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
        
    }
    
    func ajustTimeStamp(sample: CMSampleBuffer, offset: CMTime) -> CMSampleBuffer {
        var count: CMItemCount = 0
        CMSampleBufferGetSampleTimingInfoArray(sample, 0, nil, &count);
        var info = [CMSampleTimingInfo](repeating: CMSampleTimingInfo(duration: CMTimeMake(0, 0), presentationTimeStamp: CMTimeMake(0, 0), decodeTimeStamp: CMTimeMake(0, 0)), count: count)
        CMSampleBufferGetSampleTimingInfoArray(sample, count, &info, &count);
        
        for i in 0..<count {
            info[i].decodeTimeStamp = CMTimeSubtract(info[i].decodeTimeStamp, offset);
            info[i].presentationTimeStamp = CMTimeSubtract(info[i].presentationTimeStamp, offset);
        }
        
        var out: CMSampleBuffer?
        CMSampleBufferCreateCopyWithNewTiming(nil, sample, count, &info, &out);
        return out!
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
        let isVideo = output is AVCaptureVideoDataOutput
        let isAudio = output is AVCaptureAudioDataOutput
        
        if isVideo && videoWriterInput.isReadyForMoreMediaData {
            newVideoSample(sampleBuffer: sampleBuffer)
        } else if isAudio && audioWriterInput.isReadyForMoreMediaData {
            newAudioSample(sampleBuffer: sampleBuffer)
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
func printIsolated(message: String = "",
                   object: Any) {
    print("--------------\(message)-----------------")
    print(object)
    print("-------------------------------")
}
