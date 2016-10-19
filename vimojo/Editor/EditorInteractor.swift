//
//  EditorInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AssetsLibrary
import AVFoundation
import VideonaProject


class EditorInteractor: NSObject,EditorInteractorInterface {
    
    //MARK: - Variables VIPER
    var delegate:EditorInteractorDelegate?
    var project:Project?
    
    var videosList:[Video] = []

    override init() {
        guard let videosList = project?.getVideoList() else{return}
        
        self.videosList = videosList
    }
    
    func getListData(){
        guard let videosList = project?.getVideoList() else{return}
        
        self.videosList = videosList
        
        self.getVideoList()
        self.getStopTimeList()
    }
    
    func getVideoList(){
        var videoList:[EditorViewModel] = []
        
        for video in self.videosList{

            ThumbnailListInteractor(videoPath: video.getMediaPath(),
                diameter: Utils.sharedInstance.thumbnailEditorListDiameter).getThumbnailImage({
                    thumb in
                    
                    let timeToString = self.hourToString(video.getStopTime() - video.getStartTime())
                    let newVideo = EditorViewModel(
                        image: thumb,
                        timeText: timeToString,
                        positionText: "\(video.getPosition())")
                    videoList.append(newVideo)
                })
        }
        delegate?.setVideoList(videoList)
    }
    
    func hourToString(time:Double) -> String {
        let hours = Int(floor(time/3600))
        let mins = Int(floor(time % 3600) / 60)
        let secs = Int(floor(time % 3600) % 60)
        
        let x:Double = (time % 3600) % 60
        let numberOfPlaces:Double = 4.0
        let powerOfTen:Double = pow(10.0, numberOfPlaces)
        let targetedDecimalPlaces:Double = round((x % 1.0) * powerOfTen) / powerOfTen
        
        let decimals = Int(targetedDecimalPlaces * 1000)
        
        //        return String(format:"%d:%02d:%02d,%02d", hours, mins, secs,decimals)
        //        return String(format:"%02d:%02d:%02d", mins, secs,decimals)
                return String(format:"%02d:%02d", mins, secs)
    }
    func getStopTimeList(){
        var stopTimeList:[Double] = []
        
        var stopTimeAcumulator = 0.0
        for video in videosList{
            stopTimeAcumulator += (video.getStopTime() - video.getStartTime())
            stopTimeList.append(stopTimeAcumulator)
        }
        
        delegate?.setStopTimeList(stopTimeList)
    }
    
    func saveVideoToDocuments(url:NSURL) {
        self.exportWithoutWaterMark(url, completionHandler: {
            path in
            
            AddVideoToProjectUseCase.sharedInstance.add(path,
                title: "Video from library",
                project: self.project!)
            
            self.updateNewVideoValues()
        })
    }
    
    func updateNewVideoValues(){
        guard let videoList = project?.getVideoList() else{return}
        
        videoList.last?.mediaRecordedFinished()
        
        delegate?.updateViewList()
    }
    
    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }
    
    func getNewClipPath(title:String)->String{
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
    }
    
    func exportWithoutWaterMark(urlPath:NSURL, completionHandler:(String)->Void){
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrackWithMediaType(AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // - Add assets to the composition
        
        // 2 - Get Video asset
        let videoURL: NSURL = urlPath
        let videoAsset = AVAsset.init(URL: videoURL)
        
        do {
            let startTime = kCMTimeZero
            
            let stopTime = videoAsset.duration
            
            try videoTrack.insertTimeRange(CMTimeRangeMake(startTime,  stopTime),
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeVideo)[0] ,
                                           atTime: kCMTimeZero)
            
            try audioTrack.insertTimeRange(CMTimeRangeMake(startTime, stopTime),
                                           ofTrack: videoAsset.tracksWithMediaType(AVMediaTypeAudio)[0] ,
                                           atTime: kCMTimeZero)
            
        } catch _ {
            Utils().debugLog("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        ////////////////////////////////////////////////////////////////
        
        // 5 - Create Exporter
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let savePath = (documentDirectory as NSString).stringByAppendingPathComponent("\(Utils().giveMeTimeNow())videonaClip.m4v")
        
        let url = NSURL(fileURLWithPath: savePath)
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter!.outputURL = url
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        
        // 6 - Perform the Export
        exporter!.exportAsynchronouslyWithCompletionHandler() {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
        
                completionHandler(savePath)
            })
        }
    }
    
    func seekToSelectedItemHandler(videoPosition: Int) {
        let time = getSeekTimePercentForSelectedVideo(videoPosition)
        
        delegate?.seekToTimeOfVideoSelectedReceiver(time)
    }
    
    func getSeekTimePercentForSelectedVideo(videoPosition:Int) -> Float {
        guard let videoList = project?.getVideoList() else{return 0.0}
        
        var timeFloat = 0.0
        var totalTimeComposition = 0.0
        
        if (videoPosition <= (videoList.count - 1)) && videoPosition != 0{
            for count in 0...(videoList.count - 1) {
                let video = videoList[count]
                let duration = video.getDuration()
                if(count < videoPosition){
                    print("duration of seek video:\(duration)")
                    timeFloat += duration
                }
                totalTimeComposition += duration
            }
            timeFloat = timeFloat/totalTimeComposition
            let timeOffSet = 0.001
            timeFloat = ((round(10000*timeFloat)/10000) + timeOffSet)
        }

        return Float(timeFloat)
    }
    
    func reloadPositionNumberAfterMovement() {
        guard let videoList = project?.getVideoList() else{return}
        
        if !videoList.isEmpty {
            for videoPosition in 1...(videoList.count) {
                videoList[videoPosition - 1].setPosition(videoPosition)
            }
            
            project?.setVideoList(videoList)
        }
    }
    
    func removeVideo(index:Int){
        guard var videoList = project?.getVideoList() else{return}
        
        videoList.removeAtIndex(index)
        
        project?.setVideoList(videoList)
    }
    
    func getProject() -> Project {
        return project!
    }
    
    func moveClipToPosition(sourcePosition:Int,
                            destionationPosition:Int){
        guard var videoList = project?.getVideoList() else{return}
        
        let videoToMove = videoList[sourcePosition]
        videoList.removeAtIndex(sourcePosition)
        videoList.insert(videoToMove, atIndex: destionationPosition)
        
        project?.setVideoList(videoList)
    }
    
    func getNumberOfClips() -> Int {
        guard let numberOfClips = project?.numberOfClips() else {return 0}
        return numberOfClips
    }
    
    func getVideoTextInPosition(position: Int) {
        guard let videoList = project?.getVideoList() else {return}
        
        if videoList.indices.contains(position)
        {
            let video = videoList[position]
            
            let text = video.textToVideo
            
            //TODO:
            guard let textPosition =  CATextLayerAttributes.VerticalAlignment(rawValue: video.textPositionToVideo) else {
                print("Not valid position")
                return}
            
            let image = GetImageByTextUseCase().getTextImage(text,
                                                             attributes:CATextLayerAttributes().getAlignmentAttributesByType(textPosition))
            delegate?.setVideoTextImageToPlayer(image)
        }
    }
}