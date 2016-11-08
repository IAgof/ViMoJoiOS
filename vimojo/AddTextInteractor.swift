//
//  AddTextInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class AddTextInteractor: AddTextInteractorInterface {
    var delegate:AddTextInteractorDelegate?
    var project:Project?
    var videoPosition:Int?

    let fontSize = CGFloat(80)
    
    init(project:Project){
        self.project = project
    }
    
    var alignmentType:CATextLayerAttributes.VerticalAlignment = .top
    
    func getAlignmentAttributesByType(type:AlignmentTypes)->CATextLayerAttributes{
        switch type {
        case .Top:
           return CATextLayerAttributes(horizontalAlignment: .left,
                                  verticalAlignment: .top,
                                  font: .bold,
                                  fontSize: .medium)
        case .Mid:
           return CATextLayerAttributes(horizontalAlignment: .center,
                                  verticalAlignment: .mid,
                                  font: .bold,
                                  fontSize: .medium)
        case .Bottom:
          return  CATextLayerAttributes(horizontalAlignment: .left,
                                  verticalAlignment: .bottom,
                                  font: .light,
                                  fontSize: .medium)
        }
    }
    
    func setAlignment(alignment:CATextLayerAttributes.VerticalAlignment,
                      text:String){
        alignmentType = alignment
        
        getLayerToPlayer(text)
    }
    
    func getVideoParams() {
        guard let position = videoPosition else{return}
        guard let video = project?.getVideoList()[position]else {return}
        
        let text = video.textToVideo
        let textPosition = video.textPositionToVideo 
        
        delegate?.setVideoParams(text,
                                 position: textPosition)
    }
    
    func getLayerToPlayer(text: String){
        let alignmentAttributes = CATextLayerAttributes().getAlignmentAttributesByType(alignmentType)

        let image = GetImageByTextUseCase().getTextImage(text, attributes: alignmentAttributes)
        let textImageLayer = CALayer()
        textImageLayer.contents = image.CGImage
        textImageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        textImageLayer.contentsScale = UIScreen.mainScreen().scale
        
        delegate?.setAVSyncLayerToPlayer(textImageLayer)
    }
    
    func setParametersToVideo(text: String,
                              position: Int) {
        guard let videoList = project?.getVideoList() else {return}
        
        guard let vidPosition = videoPosition else{return}
        
        videoList[vidPosition].textToVideo = text
        videoList[vidPosition].textPositionToVideo = position
        
        project?.setVideoList(videoList)
    }
    
    func setVideoPosition(position: Int) {
        self.videoPosition = position
    }
    
    func setUpComposition(completion:(VideoComposition)->Void) {
        var videoTotalTime:CMTime = kCMTimeZero
        
        guard let videoPos = videoPosition else {
            return
        }
        
        guard let video = project?.getVideoList()[videoPos] else{return}
        
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        let videoURL: NSURL = video.videoURL
        let videoAsset = AVAsset.init(URL: videoURL)
        
        do {
            let startTime = CMTimeMake(Int64(video.getStartTime() * 1000), 1000)
            let stopTime = CMTimeMake(Int64(video.getStopTime() * 1000), 1000)
            
            let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
            
            try videoTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                           atTime: kCMTimeZero)
            
            try audioTrack.insertTimeRange(timeRangeInsert,
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            
            videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))
            
            mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
        } catch _ {
            print("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        
        completion(VideoComposition(mutableComposition: mixComposition))
    }
}