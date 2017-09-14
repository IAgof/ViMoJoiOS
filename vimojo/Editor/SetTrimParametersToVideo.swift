//
//  SetTrimParametersToVideo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SetTrimParametersToVideoWorker: NSObject {
    func setParameters(_ trimParams: TrimParameters,
                       project: Project,
                       videoPosition: Int) {
        let videoList = project.getVideoList()
        if videoList.indices.contains(videoPosition) {
            videoList[videoPosition].setStartTime(trimParams.startTime)
            videoList[videoPosition].setStopTime(trimParams.stopTime)

            project.setVideoList(videoList)

            project.updateModificationDate()
            ProjectRealmRepository().update(item: project)
        }
    }
}
