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

    public func map(from: RealmProject) -> Project {
        let profile = mapProfile(realmProject: from)
        
        let project = Project(title: from.title,
                              rootPath: "",
                              profile: profile)
        project.uuid = from.uuid
        project.setExportedPath(path: from.exportedPath)
        project.exportDate = from.exportedDate
        project.modificationDate = from.modificationDate
        project.isVoiceOverSet = from.isVoiceOverSet
        project.voiceOver = Audio(title: "", mediaPath: from.voiceOverPath)
        project.voiceOver.audioLevel = from.voiceOverAudioLevel
        
        setProjectMusic(project: project, realmProject: from)
        setProjectVideos(project: project, realmProject: from)
        
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
        music.volume = realmProject.musicVolume
        
        project.setMusic(music)
    }
    
    func setProjectVideos(project:Project,realmProject:RealmProject){
        var videoList = project.getVideoList()
        
        for realmVideo in realmProject.videos{
            videoList.append(toVideoMapper.map(from: realmVideo))
        }
        
        project.setVideoList(videoList)
    }
}
