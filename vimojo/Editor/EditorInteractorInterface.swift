//
//  EditorInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

protocol EditorInteractorInterface {
    func getComposition()
    func getListData()
    func seekToSelectedItemHandler(_ videoPosition:Int)
    func reloadPositionNumberAfterMovement()
    func removeVideo(_ index:Int)
    func moveClipToPosition(_ sourcePosition:Int,
                            destionationPosition:Int)
    func getNumberOfClips()->Int
    func getProject()->Project
    
    func updateSeekOnVideoTo(_ value:Double,
                             videoNumber:Int)
    func setRangeSliderMiddleValueUpdateWith(actualVideoNumber videoNumber:Int,
                                                               seekBarValue:Float)
    func setRangeSliderViewValues(actualVideoNumber videoNumber: Int)
    
    func getCompositionForVideo(_ videoPosition:Int)
    
    func setTrimParametersToProject(_ startTime:Double,
                                    stopTime:Double,
                                    videoPosition:Int)
}

protocol EditorInteractorDelegate {
    func setVideoList(_ list:[EditorViewModel])
    func setStopTimeList(_ list:[Double])
    func updateViewList()
    func seekToTimeOfVideoSelectedReceiver(_ time:Float)
    
    func setComposition(_ composition:VideoComposition)
    
    func setTrimRangeSliderViewModel(_ viewModel:TrimRangeBarViewModel)
    func setTrimMiddleValue(_ value:Double)
}
