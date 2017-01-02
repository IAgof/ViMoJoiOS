//
//  ProjectToRealmProjectMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class ProjectToRealmProjectMapper:Mapper{
    public typealias From = Project
    public typealias To = RealmProject
    
    let toRealmVideoMapper = VideoToRealmVideoMapper()
    
    public func map(from: Project) -> RealmProject {
        let realmProject = RealmProject()
        realmProject.title = from.getTitle()
        realmProject.projectPath = from.getProjectPath()
        realmProject.quality = from.getProfile().getQuality()
        realmProject.resolution = from.getProfile().getResolution()
        realmProject.frameRate = from.getProfile().frameRate
        realmProject.uuid = from.uuid
        realmProject.exportedDate = from.exportDate
        realmProject.modificationDate = from.modificationDate
        realmProject.exportedPath = from.getExportedPath()
        realmProject.isVoiceOverSet = from.isVoiceOverSet
        realmProject.voiceOverPath = from.voiceOver.getMediaPath()
        realmProject.voiceOverAudioLevel = from.voiceOver.audioLevel
        
        if from.isMusicSet{
            realmProject.musicTitle = from.getMusic().getTitle()
            realmProject.musicVolume = from.getMusic().volume
        }
        
        for video in from.getVideoList(){
            realmProject.videos.append(toRealmVideoMapper.map(from: video))
        }
        
        return realmProject
    }
}
    
