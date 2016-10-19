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
        
        getTextImage(text)
    }
    
    func getVideoParams() {
        guard let position = videoPosition else{return}
        guard let video = project?.getVideoList()[position]else {return}
        
        let text = video.textToVideo
        let textPosition = video.textPositionToVideo 
        
        delegate?.setVideoParams(text,
                                 position: textPosition)
    }
    
    func getTextImage(text: String) {
        let alignmentAttributes = CATextLayerAttributes().getAlignmentAttributesByType(alignmentType)
        
        let image = GetImageByTextUseCase().getTextImage(text, attributes: alignmentAttributes)
        
        delegate?.setTextImageToPlayer(image)
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
        let videoURL: NSURL = NSURL.init(fileURLWithPath: video.getMediaPath())
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
    
    func exportVideoWithText(text:String){
        self.setUpComposition({composition in
            guard let mutableComposition = composition.mutableComposition else{return}
            let videoComposition = AVMutableVideoComposition(propertiesOfAsset: mutableComposition)
            self.applyVideoOverlayAnimation(videoComposition,
                mutableComposition: mutableComposition,
                size: videoComposition.renderSize,
                text: text)
            
            self.exportComposition(mutableComposition,videoComposition: videoComposition)
        })
    }
    
    
    func applyVideoOverlayAnimation(composition:AVMutableVideoComposition,
                                    mutableComposition:AVMutableComposition,
                                    size:CGSize,
                                    text:String){
        
        print("vodeo size: \(size)")
        
        let overlaySize = CGSize(width: size.width, height: size.height/3)
        let overlayFrame = CGRect(origin: CGPointZero, size: overlaySize)
        
        let overlayLayer = getTextLayer(text, frame: overlayFrame)
        
        let overlayPosition = CGPoint(x: 0, y: size.height*2/3)
        
        overlayLayer.frame = CGRect(origin: overlayPosition, size: overlaySize)
        
        let videoLayer = CALayer()
        videoLayer.frame = CGRectMake(0, 0, size.width, size.height)
        videoLayer.masksToBounds = true
        
        
        let parentLayer = CALayer()
        parentLayer.frame = CGRectMake(0, 0, size.width, size.height)
        parentLayer.addSublayer(videoLayer)
        parentLayer.addSublayer(overlayLayer)
        
        let animation = CAAnimation()
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, inLayer: parentLayer)
    }
    
    func getTextLayer(text:String,
                      frame:CGRect)->CATextLayer{
        // 1
        let textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.string = text
        
        // 3
        let fontName: CFStringRef = "Helvetica"
        textLayer.font = CTFontCreateWithName(fontName, 80, nil)

        textLayer.fontSize = fontSize
        
        // 4
        textLayer.foregroundColor = UIColor.whiteColor().CGColor
        textLayer.wrapped = true
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.contentsScale = UIScreen.mainScreen().scale
        
        return textLayer
    }
    
    func exportComposition(composition:AVMutableComposition,
                           videoComposition:AVMutableVideoComposition){
        var exportPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        exportPath = "\(exportPath)/videoWithText\(Utils().giveMeTimeNow()).m4v"
        
        // 4 - Get path
        let url = NSURL(fileURLWithPath: exportPath)
        
        // 5 - Create Exporter
        
        guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else{return}
        exporter.videoComposition = videoComposition
        exporter.outputURL = url
        exporter.outputFileType = AVFileTypeMPEG4
        exporter.shouldOptimizeForNetworkUse = true
        
        // 6 - Perform the Export
        exporter.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.addVideoWithTextToProject(exportPath)
            })
        }
    }
    
    func addVideoWithTextToProject(exportPath:String){
        guard let videoList = project?.getVideoList() else {return}
        
        let video = Video.init(title: "Text", mediaPath: exportPath)
        
        AddVideoToProjectUseCase().add(video,
                                       position: videoList.count,
                                       project: project!)
        video.mediaRecordedFinished()
    }
}