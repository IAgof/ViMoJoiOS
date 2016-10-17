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
    func getListData()
    func saveVideoToDocuments(url:NSURL)
    func seekToSelectedItemHandler(videoPosition:Int)
    func reloadPositionNumberAfterMovement()
    func removeVideo(index:Int)
    func moveClipToPosition(sourcePosition:Int,
                            destionationPosition:Int)
    func getNumberOfClips()->Int
    func getProject()->Project
    func getVideoTextInPosition(position:Int)
}

protocol EditorInteractorDelegate {
    func setVideoList(list:[EditorViewModel])
    func setStopTimeList(list:[Double])
    func updateViewList()
    func seekToTimeOfVideoSelectedReceiver(time:Float)
    
    func setVideoTextToPlayer(text:String,
                              position:Int)
}