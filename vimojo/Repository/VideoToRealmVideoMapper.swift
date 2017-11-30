//
//  VideoToRealmVideoMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class VideoToRealmVideoMapper: Mapper {
    public typealias From = Video
    public typealias To = RealmVideo

    public func map(from: Video) -> RealmVideo {
        let realmVideo = RealmVideo()

        realmVideo.uuid = from.uuid
        realmVideo.title = from.getTitle()
        realmVideo.mediaPath = from.getMediaPath()
        realmVideo.position = from.getPosition()
        realmVideo.startTime = from.getStartTime()
        realmVideo.stopTime = from.getStopTime()
        realmVideo.clipTextPosition = from.textPositionToVideo
        realmVideo.clipText = from.textToVideo
        realmVideo.videoURL = from.videoURL.absoluteString
		realmVideo.fileStopTime = from.fileStopTime
		// TODO: change data unwrapping
		if let image = from.thumbnailImage { realmVideo.thumbnailData = (UIImagePNGRepresentation(image) as! Data) }

        return realmVideo
    }
}
