//
//  RealmAudioToAudioMapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class RealmAudioToAudioMapper: Mapper {
    public typealias From = RealmAudio
    public typealias To = Audio

    public func map(from: RealmAudio) -> Audio {
        let audio = Audio(title: from.title,
                          mediaPath: from.mediaPath)

        audio.uuid = from.uuid
        audio.setStartTime(from.startTime)
        audio.setStopTime(from.stopTime)

        return audio
    }
}
