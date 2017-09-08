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
    let toRealmAudioMapper = AudioToRealmAudioMapper()
    
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
        realmProject.transitionTime = from.transitionTime
        realmProject.projectOutputAudioLevel = from.projectOutputAudioLevel
        
        realmProject.brightnessLevel = from.videoOutputParameters.brightness
        realmProject.contrastLevel = from.videoOutputParameters.contrast
        realmProject.exposureLevel = from.videoOutputParameters.exposure
        realmProject.saturationLevel = from.videoOutputParameters.saturation
        realmProject.hasWatermark = from.hasWatermark
        
        if let filter = from.videoFilter{
            realmProject.filterName = filter.name
        }

        if let music = from.music{
            realmProject.musicTitle = music.getTitle()
            realmProject.musicVolume = Double(music.audioLevel)
        }
        
        for video in from.getVideoList(){
            realmProject.videos.append(toRealmVideoMapper.map(from: video))
        }
        
        for audio in from.voiceOver{
            realmProject.voiceOver.append(toRealmAudioMapper.map(from: audio))
        }
        return realmProject
    }
}
    
