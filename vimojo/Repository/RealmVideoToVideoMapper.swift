//
//  RealmVideoToVideoMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class RealmVideoToVideoMapper:Mapper{
    public typealias From = RealmVideo
    public typealias To = Video

    public func map(from: RealmVideo) -> Video {
        let video = Video(title: from.title,
                          mediaPath: from.mediaPath)
        video.uuid = from.uuid
        video.setPosition(from.position)
        video.setStopTime(from.stopTime)
        video.setStartTime(from.startTime)
        video.textToVideo = from.clipText
        video.textPositionToVideo = from.clipTextPosition
        video.videoURL = URL(string: from.videoURL)!
        
        video.setDefaultVideoParameters()
                
        return video
    }
}

extension String{
    var fileExists: Bool{
        return FileManager.default.fileExists(atPath: self)
    }
}