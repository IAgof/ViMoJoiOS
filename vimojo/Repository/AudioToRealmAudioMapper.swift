//
//  AudioToRealmAudioMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class AudioToRealmAudioMapper: Mapper {
    public typealias From = Audio
    public typealias To = RealmAudio

    public func map(from: Audio) -> RealmAudio {
        let realmAudio = RealmAudio()

        realmAudio.uuid = from.uuid
        realmAudio.title = from.getTitle()
        realmAudio.mediaPath = from.getMediaPath()
        realmAudio.startTime = from.getStartTime()
        realmAudio.stopTime = from.getStopTime()

        return realmAudio
    }
}
