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
    func getListData(completion: ([EditorViewModel]) -> Void)
    func seekToSelectedItemHandler(_ videoPosition: Int)
    func removeVideo(_ index: Int)
    func moveClipToPosition(_ sourcePosition: Int,
                            destionationPosition: Int)
    func getNumberOfClips() -> Int
    func getProject() -> Project

    func updateSeekOnVideoTo(_ value: Double,
                             videoNumber: Int)
    func getCompositionForVideo(_ videoPosition: Int)
}

protocol EditorInteractorDelegate {
    func setStopTimeList(_ list: [Double])
    func seekToTimeOfVideoSelectedReceiver(_ time: Float)

    func setComposition(_ composition: VideoComposition)
}
