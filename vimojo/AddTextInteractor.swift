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
    
    func getAlignmentAttributesByType(_ type:AlignmentTypes)->CATextLayerAttributes{
        switch type {
        case .top:
           return CATextLayerAttributes(horizontalAlignment: .left,
                                  verticalAlignment: .top,
                                  font: .bold,
                                  fontSize: .medium)
        case .mid:
           return CATextLayerAttributes(horizontalAlignment: .center,
                                  verticalAlignment: .mid,
                                  font: .bold,
                                  fontSize: .medium)
        case .bottom:
          return  CATextLayerAttributes(horizontalAlignment: .left,
                                  verticalAlignment: .bottom,
                                  font: .light,
                                  fontSize: .medium)
        }
    }
    
    func setAlignment(_ alignment:CATextLayerAttributes.VerticalAlignment,
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
    
    func getLayerToPlayer(_ text: String){
        let alignmentAttributes = CATextLayerAttributes().getAlignmentAttributesByType(type: alignmentType)

        let image = GetImageByTextUseCase().getTextImage(text: text, attributes: alignmentAttributes)
        let textImageLayer = CALayer()
        textImageLayer.contents = image.cgImage
        textImageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        textImageLayer.contentsScale = UIScreen.main.scale
        
        delegate?.setAVSyncLayerToPlayer(textImageLayer)
    }
    
    func setParametersToVideo(_ text: String,
                              position: Int) {
        guard let videoList = project?.getVideoList() else {return}
        
        guard let vidPosition = videoPosition else{return}
        guard let actualProject = project else{return}
        
        videoList[vidPosition].textToVideo = text
        videoList[vidPosition].textPositionToVideo = position
        
        actualProject.setVideoList(videoList)
        
        ProjectRealmRepository().update(item: actualProject)
    }
    
    func setVideoPosition(_ position: Int) {
        self.videoPosition = position
    }
    
    func setUpComposition(_ completion:(VideoComposition)->Void) {
        var videoTotalTime:CMTime = kCMTimeZero
        
        guard let videoPos = videoPosition else {
            return
        }
        
        guard let video = project?.getVideoList()[videoPos] else{return}
        
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // 2 - Get Video asset
        let videoURL: URL = video.videoURL
        let videoAsset = AVAsset.init(url: videoURL)
        
        do {
            let startTime = CMTimeMake(Int64(video.getStartTime() * 600), 600)
            let stopTime = CMTimeMake(Int64(video.getStopTime() * 600), 600)
            
            let timeRangeInsert = CMTimeRangeMake(startTime, stopTime)
            
            try videoTrack.insertTimeRange(timeRangeInsert,
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                           at: kCMTimeZero)
            
            try audioTrack.insertTimeRange(timeRangeInsert,
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                           at: kCMTimeZero)
            
            videoTotalTime = CMTimeAdd(videoTotalTime, (stopTime - startTime))
            
            mixComposition.removeTimeRange(CMTimeRangeMake((videoTotalTime), (stopTime + videoTotalTime)))
        } catch _ {
            print("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        
        completion(VideoComposition(mutableComposition: mixComposition))
    }
}
