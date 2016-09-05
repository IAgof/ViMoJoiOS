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
import Project

class CameraRecorderInteractor{

    var filterToWriter :GPUImageFilter?
    var movieWriter: GPUImageMovieWriter?
    var clipsArray:[String] = []
    var videoCamera: GPUImageVideoCamera?
    var resolutionSize:Resolution?
    var project:Project?
    
    var resolution: String?{
        didSet {
            resolutionSize = Resolution.init(AVResolution: resolution!)
        }
    }
    
    init(project:Project){
        self.project = project
    }
    
    func recordVideo(completion:(String)->Void){
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let title = self.getNewTitle()
            let clipPath = self.getNewClipPath(title)
            self.clipsArray.append(clipPath)
            
            AddVideoToProjectUseCase.sharedInstance.add(clipPath,
                                                        title: title,
                                                        project: self.project!)
            
            print("Number of clips in project :\n \(self.project?.numberOfClips())")
            
            let clipURL = NSURL.init(fileURLWithPath: clipPath)
            
            Utils().debugLog("PathToMovie: \(clipPath)")
            self.movieWriter = GPUImageMovieWriter.init(movieURL: clipURL, size: CGSizeMake((self.resolutionSize?.width)!,(self.resolutionSize?.height)!))
            
            self.movieWriter!.encodingLiveVideo = true
            self.videoCamera?.audioEncodingTarget = self.movieWriter
            
            self.movieWriter!.startRecording()
            
            Utils().debugLog("Recording movie starts")
            self.filterToWriter?.addTarget(self.movieWriter)
        }
        completion("Record Starts")
    }
    
    func stopRecordVideo(completion:(Double)->Void){ //Stop Recording
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            Utils().debugLog("Starting to stop record video")
            
            self.filterToWriter!.removeAllTargets()
            
//            self.videoCamera.audioEncodingTarget = nil
            
            self.movieWriter!.finishRecordingWithCompletionHandler{ () -> Void in
                let clipURL = NSURL.init(fileURLWithPath: self.clipsArray[(self.clipsArray.count - 1) ])

                Utils().debugLog("Stop recording video")
                
                AddVideoToProjectUseCase.sharedInstance.updateVideoParams(self.project!)
                ClipsAlbum.sharedInstance.saveVideo(clipURL)
                
                self.movieWriter!.endProcessing()
                self.movieWriter = nil
                
                completion(self.getVideoLenght(clipURL))
            }
        }
    }
    
    func getVideoLenght(url:NSURL) -> Double {
        let asset = AVAsset.init(URL: url)
        return asset.duration.seconds
    }
    func setInput(input: GPUImageInput){
        self.filterToWriter = input as? GPUImageFilter
        if movieWriter != nil{
            filterToWriter?.addTarget(movieWriter)
        }
    }
    
    func setVideoCamera(videoCamera: GPUImageVideoCamera){
        self.videoCamera = videoCamera
    }
    
    func setResolution(resolution:String){
        self.resolution = resolution
    }
    
    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }
    
    func getNewClipPath(title:String)->String{
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
    }
    
}