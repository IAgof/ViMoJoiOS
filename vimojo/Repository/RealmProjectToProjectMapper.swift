//
//  RealmProjectToProjectMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class RealmProjectToProjectMapper:Mapper{
    public typealias From = RealmProject
    public typealias To = Project
    
    let musicSource = MusicProvider()
    var toVideoMapper = RealmVideoToVideoMapper()
    var toAudioMapper = RealmAudioToAudioMapper()

    public func map(from: RealmProject) -> Project {
        let profile = mapProfile(realmProject: from)
        
        let project = Project(title: from.title,
                              rootPath: "",
                              profile: profile)
        project.uuid = from.uuid
        project.setExportedPath(path: from.exportedPath)
        project.exportDate = from.exportedDate
        project.modificationDate = from.modificationDate
        project.transitionTime = from.transitionTime
        project.projectOutputAudioLevel = from.projectOutputAudioLevel
        
        project.videoOutputParameters.brightness = from.brightnessLevel
        project.videoOutputParameters.contrast = from.contrastLevel
        project.videoOutputParameters.exposure = from.exposureLevel
        project.videoOutputParameters.saturation = from.saturationLevel

        if from.filterName != ""{
            if let newFilter = CIFilter(name: from.filterName){
                project.videoFilter = newFilter
            }
        }
        
        setProjectMusic(project: project, realmProject: from)
        setProjectVideos(project: project, realmProject: from)
        setProjectVoiceOver(project: project, realmProject: from)
        
        return project
    }
    
    func mapProfile(realmProject:RealmProject)->Profile {
        
        let resolution = realmProject.resolution
        let quality = realmProject.quality
        let frameRate = realmProject.frameRate
        
        return Profile(resolution: resolution,
                       videoQuality: quality,
                       frameRate: frameRate);
    }
    
    func setProjectMusic(project:Project,realmProject:RealmProject){
        let musicTitle = realmProject.musicTitle
        guard let music = musicSource.getMusicByTitle(title: musicTitle) else {
            print("Cant get music")
            return
        }
        music.audioLevel = Float(realmProject.musicVolume)
        
        project.music = music
    }
    
    func setProjectVideos(project:Project,realmProject:RealmProject){
        var videoList = project.getVideoList()
        
        let videoListFiltered = realmProject.videos.filter { (video) -> Bool in
            return video.videoURL.fileExists
        }
        
        for realmVideo in videoListFiltered{
            videoList.append(toVideoMapper.map(from: realmVideo))
        }
        
        project.setVideoList(videoList)
    }
    
    func setProjectVoiceOver(project:Project,realmProject:RealmProject){
        var audioList = project.voiceOver
        
        for realmAudio in realmProject.voiceOver{
            audioList.append(toAudioMapper.map(from: realmAudio))
        }
        
        project.voiceOver = audioList
    }
}
