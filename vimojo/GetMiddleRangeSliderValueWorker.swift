//
//  GetMiddleRangeSliderValueWorker.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 17/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class GetMiddleRangeSliderValueWorker: NSObject {
    func getValue(value:Double,
                  project:Project,
                  videoNumber:Int) -> Double{
        var totalTime:Double = 0
        let videos = project.getVideoList()
        
        for video in videos{
            if video.getPosition() == (videoNumber + 1){
                var rangeSliderValue:Double = 0
                if totalTime > 0{
                    rangeSliderValue =   value - totalTime + video.getStartTime()
                }else{
                    rangeSliderValue =  value + video.getStartTime()
                }
                
                return rangeSliderValue
            }
            totalTime += video.getDuration() //- project.transitionTime
        }
        return 0
    }
}