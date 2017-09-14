//
//  CameraRecorderInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage
import AVFoundation
import VideonaProject

class CameraRecorderInteractor {

    var filterToWriter: GPUImageFilter?
    var movieWriter: GPUImageMovieWriter?
    var clipsArray: [String] = []
    var videoCamera: GPUImageVideoCamera?
    var resolutionSize: Resolution?
    var project: Project?

    var resolution: String? {
        didSet {
            resolutionSize = Resolution.init(AVResolution: resolution!)
        }
    }

    init(project: Project) {
        self.project = project
    }

    func recordVideo(_ completion: (String) -> Void) {
        let title = self.getNewTitle()
        let clipPath = self.getNewClipPath(title)
        self.clipsArray.append(clipPath)

        AddVideoToProjectUseCase().add(videoPath: clipPath,
                                       title: title,
                                       project: self.project!)

        print("Number of clips in project :\n \(self.project?.numberOfClips())")

        let clipURL = URL.init(fileURLWithPath: clipPath)

        DispatchQueue.main.async(execute: { () -> Void in

            Utils().debugLog("PathToMovie: \(clipPath)")
            self.movieWriter = GPUImageMovieWriter.init(movieURL: clipURL, size: CGSize(width: (self.resolutionSize?.width)!, height: (self.resolutionSize?.height)!))

            self.movieWriter!.encodingLiveVideo = true
            self.videoCamera?.audioEncodingTarget = self.movieWriter

            self.movieWriter!.startRecording()

            Utils().debugLog("Recording movie starts")
            self.filterToWriter?.addTarget(self.movieWriter)
        })
        completion("Record Starts")
    }

    func stopRecordVideo(_ completion:@escaping (Double, URL) -> Void) { //Stop Recording

        DispatchQueue.global().async {
            // do some task
            Utils().debugLog("Starting to stop record video")

            self.filterToWriter!.removeAllTargets()

            //            self.videoCamera.audioEncodingTarget = nil

            self.movieWriter!.finishRecording { () -> Void in
                let clipURL = URL.init(fileURLWithPath: self.clipsArray[(self.clipsArray.count - 1) ])

                Utils().debugLog("Stop recording video")

                guard let actualProject = self.project else {return}

                ClipsAlbum.sharedInstance.saveVideo(clipURL, project: actualProject, completion: {
                    saved, videoURL in
                    if saved, let videoURLAssets = videoURL {
                        completion(self.getVideoLenght(clipURL), videoURLAssets)
                    }
                })

                self.movieWriter!.endProcessing()
                self.movieWriter = nil
            }
        }
    }

    func getVideoLenght(_ url: URL) -> Double {
        let asset = AVAsset.init(url: url)
        return asset.duration.seconds
    }
    func setInput(_ input: GPUImageInput) {
        self.filterToWriter = input as? GPUImageFilter
        if movieWriter != nil {
            filterToWriter?.addTarget(movieWriter)
        }
    }

    func setVideoCamera(_ videoCamera: GPUImageVideoCamera) {
        self.videoCamera = videoCamera
    }

    func setResolution(_ resolution: String) {
        self.resolution = resolution
    }

    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }

    func getNewClipPath(_ title: String) -> String {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
    }

}
