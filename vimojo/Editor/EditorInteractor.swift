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
import Photos

class EditorInteractor: NSObject,EditorInteractorInterface {
    
    //MARK: - Variables VIPER
    var delegate:EditorInteractorDelegate?
    var project:Project?
    
    var videosList:[Video] = []
    var videoCount:Int?
    
    init( project:Project) {
        videosList = project.getVideoList()
        
        self.project = project
    }
    
    func getListData(){
        updateListDataParams()
        self.getVideoListToView()
    }
    
    func updateListDataParams(){
        guard let videosList = project?.getVideoList() else{return}
        
        self.videosList = videosList
        self.updateProjectForSplitAndDuplicateChanges()
        self.getStopTimeList()
    }
    
    func updateProjectForSplitAndDuplicateChanges(){
        guard let actualProject = project else{return}
        actualProject.updateModificationDate()
        ProjectRealmRepository().update(item: actualProject)
    }
    
    func getComposition() {
        guard let actualProject = project else{return}
        let videonaComposition = GetActualProjectAVCompositionUseCase().getComposition(project: actualProject)
        let animatedLayer = GetActualProjectCALayerAnimationUseCase(videonaComposition: videonaComposition).getCALayerAnimation(project: actualProject)
        videonaComposition.layerAnimation = animatedLayer
        
        DispatchQueue.main.async {
            self.delegate?.setComposition(videonaComposition)
        }
    }
    
    func getVideoListToView(){
        DispatchQueue.main.async {
            var videoListToView:[EditorViewModel] = []
            
            for video in self.videosList{
                let timeToString = self.hourToString(video.getStopTime() - video.getStartTime())
                videoListToView.append(EditorViewModel(
                    phAsset: video.videoPHAsset,
                    timeText: timeToString,
                    positionText: "\(video.getPosition())"))
            }
            self.delegate?.setVideoList(videoListToView)
        }

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

    func getNewTitle() -> String {
        return "\(Utils().giveMeTimeNow())videonaClip.m4v"
    }
    
    func getNewClipPath(_ title:String)->String{
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        path =  path + "/\(title)"
        return path
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
    
    func removeVideo(_ index:Int){
        guard var videoList = project?.getVideoList() else{return}
        
        guard let actualProject = project else{return}
        videoList.remove(at: index)
        
        actualProject.setVideoList(videoList)
        
        actualProject.updateModificationDate()
        self.getListData()
        self.getComposition()
        ProjectRealmRepository().update(item: actualProject)
    }
    
    func getProject() -> Project {
        return project!
    }
    
    func moveClipToPosition(_ sourcePosition:Int,
                            destionationPosition:Int){
        guard var videoList = project?.getVideoList() else{return}
        guard let actualProject = project else{return}

        let videoToMove = videoList[sourcePosition]
        videoList.remove(at: sourcePosition)
        videoList.insert(videoToMove, at: destionationPosition)
        
        actualProject.setVideoList(videoList)
        actualProject.reorderVideoList()
        
        self.getComposition()
        self.getListData()
        ProjectRealmRepository().update(item: actualProject)
    }
    
    func getNumberOfClips() -> Int {
        guard let numberOfClips = project?.numberOfClips() else {return 0}
        return numberOfClips
    }

    func updateSeekOnVideoTo(_ value: Double, videoNumber: Int) {
        guard let actualProject = project else{return}

        let seekTime = GetSeekTimeFromValueOnVideoWorker().getSeekTime(value,
                                                                     project: actualProject,
                                                                     numberOfVideo: videoNumber)
        
        delegate?.seekToTimeOfVideoSelectedReceiver(Float(seekTime))
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
}
