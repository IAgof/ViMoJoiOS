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
    
    func getComposition() {
        guard let actualProject = project else{return}

        var videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project: actualProject)
        
        let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project: actualProject)
        videonaComposition.layerAnimation = layer
        
        delegate?.setComposition(videonaComposition)
    }
    
    func getVideoList(){
        var videoList:[EditorViewModel] = []
        
        for video in self.videosList{

            ThumbnailListInteractor(videoURL: video.videoURL,
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
    
    func hourToString(_ time:Double) -> String {
        let mins = Int(floor(time.truncatingRemainder(dividingBy: 3600)) / 60)
        let secs = Int(floor(time.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60))
        
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
    
    func updateNewVideoValues(){
        guard let videoList = project?.getVideoList() else{return}
        
        videoList.last?.mediaRecordedFinished()
        
        delegate?.updateViewList()
    }
    
    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }
    
    func getNewClipPath(_ title:String)->String{
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
    }
    
    func exportWithoutWaterMark(_ urlPath:URL, completionHandler:@escaping (String)->Void){
        
        // - Create AVMutableComposition object. This object will hold your AVMutableCompositionTrack instances.
        let mixComposition = AVMutableComposition()
        
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        let audioTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeAudio,
                                                                     preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        
        // - Add assets to the composition
        
        // 2 - Get Video asset
        let videoURL: URL = urlPath
        let videoAsset = AVAsset.init(url: videoURL)
        
        do {
            let startTime = kCMTimeZero
            
            let stopTime = videoAsset.duration
            
            try videoTrack.insertTimeRange(CMTimeRangeMake(startTime,  stopTime),
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0] ,
                                           at: kCMTimeZero)
            
            try audioTrack.insertTimeRange(CMTimeRangeMake(startTime, stopTime),
                                           of: videoAsset.tracks(withMediaType: AVMediaTypeAudio)[0] ,
                                           at: kCMTimeZero)
            
        } catch _ {
            Utils().debugLog("Error trying to create videoTrack")
            //                completionHandler("Error trying to create videoTrack",0.0)
        }
        ////////////////////////////////////////////////////////////////
        
        // 5 - Create Exporter
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let savePath = (documentDirectory as NSString).appendingPathComponent("\(Utils().giveMeTimeNow())videonaClip.m4v")
        
        let url = URL(fileURLWithPath: savePath)
        
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter!.outputURL = url
        exporter!.outputFileType = AVFileTypeQuickTimeMovie
        exporter!.shouldOptimizeForNetworkUse = true
        
        // 6 - Perform the Export
        exporter!.exportAsynchronously() {
            DispatchQueue.main.async(execute: { () -> Void in
        
                completionHandler(savePath)
            })
        }
    }
    
    func seekToSelectedItemHandler(_ videoPosition: Int) {
        let time = getSeekTimePercentForSelectedVideo(videoPosition)
        
        delegate?.seekToTimeOfVideoSelectedReceiver(time)
    }
    
    func getSeekTimePercentForSelectedVideo(_ videoPosition:Int) -> Float {
        guard let videoList = project?.getVideoList() else{return 0.0}
        
        var totalTimeComposition = 0.0
        
        if (videoPosition <= (videoList.count - 1)) && videoPosition != 0{
            for count in 0...(videoList.count - 1) {
                let video = videoList[count]
                let duration = video.getDuration()
                if(count < videoPosition){
                    totalTimeComposition += duration
                }
            }
        }
        return Float(totalTimeComposition)
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
    
    func removeVideo(_ index:Int){
        guard var videoList = project?.getVideoList() else{return}
        
        videoList.remove(at: index)
        
        project?.setVideoList(videoList)
    }
    
    func getProject() -> Project {
        return project!
    }
    
    func moveClipToPosition(_ sourcePosition:Int,
                            destionationPosition:Int){
        guard var videoList = project?.getVideoList() else{return}
        
        let videoToMove = videoList[sourcePosition]
        videoList.remove(at: sourcePosition)
        videoList.insert(videoToMove, at: destionationPosition)
        
        project?.setVideoList(videoList)
    }
    
    func getNumberOfClips() -> Int {
        guard let numberOfClips = project?.numberOfClips() else {return 0}
        return numberOfClips
    }

    
    func setRangeSliderMiddleValueUpdateWith(actualVideoNumber videoNumber: Int, seekBarValue: Float) {
        guard let actualProject = project else{return}

        let middleRangeValue = GetMiddleRangeSliderValueWorker().getValue(Double(seekBarValue),
                                                                          project: actualProject,
                                                                          videoNumber: videoNumber)
        delegate?.setTrimMiddleValue(middleRangeValue)
        
    }
    
    func updateSeekOnVideoTo(_ value: Double, videoNumber: Int) {
        guard let actualProject = project else{return}

        let seekTime = GetSeekTimeFromValueOnVideoWorker().getSeekTime(value,
                                                                     project: actualProject,
                                                                     numberOfVideo: videoNumber)
        
        delegate?.seekToTimeOfVideoSelectedReceiver(Float(seekTime))
    }
    
    func setRangeSliderViewValues(actualVideoNumber videoNumber: Int){
        guard let videoList = project?.getVideoList() else{return}
        
        if videoList.indices.contains(videoNumber){
            let video = videoList[videoNumber]
            
            let rangeSliderViewModel = TrimRangeBarViewModel(totalRangeTime: video.getFileStopTime(),
                                                             startTrimTime: video.getStartTime(),
                                                             finalTrimTime: video.getStopTime(),
                                                             inserctionPointTime: video.getStartTime())
            
            delegate?.setTrimRangeSliderViewModel(rangeSliderViewModel)
        }
    }
    
    func getCompositionForVideo(_ videoPosition: Int) {
        guard let actualProject = project else{return}

        GetCompositionForVideoWorker().getComposition(videoPosition,
                                                      project: actualProject,
                                                      completion: {
                                                        videoComposition in
                                                        self.delegate?.setComposition(videoComposition)
        })
    }
    
    func setTrimParametersToProject(_ startTime:Double,
                                    stopTime:Double,
                                    videoPosition:Int){
        guard let actualProject = project else{return}
        let trimParams = TrimParameters(startTime: startTime,
                                        stopTime: stopTime)
       
        SetTrimParametersToVideoWorker().setParameters(trimParams,
                                                       project: actualProject,
                                                       videoPosition: videoPosition)
    }
}
