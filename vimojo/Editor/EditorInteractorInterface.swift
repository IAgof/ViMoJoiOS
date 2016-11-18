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
    func seekToSelectedItemHandler(videoPosition:Int)
    func reloadPositionNumberAfterMovement()
    func removeVideo(index:Int)
    func moveClipToPosition(sourcePosition:Int,
                            destionationPosition:Int)
    func getNumberOfClips()->Int
    func getProject()->Project
    
    func updateSeekOnVideoTo(value:Double,
                             videoNumber:Int)
    func setRangeSliderMiddleValueUpdateWith(actualVideoNumber videoNumber:Int,
                                                               seekBarValue:Float)
    func setRangeSliderViewValues(actualVideoNumber videoNumber: Int)
}

protocol EditorInteractorDelegate {
    func setVideoList(list:[EditorViewModel])
    func setStopTimeList(list:[Double])
    func updateViewList()
    func seekToTimeOfVideoSelectedReceiver(time:Float)
    
    func setComposition(composition:VideoComposition)
    
    func setTrimRangeSliderViewModel(viewModel:TrimRangeBarViewModel)
    func setTrimMiddleValue(value:Double)
}