//
//   GetSeekTimeFromValueOnVideo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 17/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class GetSeekTimeFromValueOnVideoWorker {
    func getSeekTime(_ value: Double,
                     project: Project,
                     numberOfVideo: Int) -> Double {
        var seekTime: Double = 0

        let videos = project.getVideoList()

        for video in videos {
            if video.getPosition() <= (numberOfVideo + 1) {
                if video.getPosition() != (numberOfVideo + 1) {
                    seekTime += video.getDuration()// - project.transitionTime
                } else {
                    seekTime += (value - video.getStartTime())
                }
            }
        }
        return seekTime
    }
}
