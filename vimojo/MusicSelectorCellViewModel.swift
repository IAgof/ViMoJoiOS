//
//  MusicSelectorCellViewModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

typealias DefaultAction = () -> Void

class SelectorItem {
    //TODO: this is not the correct place to be
    let image: UIImage?
    let timeRange: CMTimeRange
    let action: DefaultAction

    init(with image: UIImage?, timeRange: CMTimeRange, action: @escaping DefaultAction = {}) {
        self.image = image
        self.action = action
        self.timeRange = timeRange
    }
}
struct AudioUpdate {
    let volume: Float
    let musicResource: MusicResource
}

class MusicSelectorCellViewModel {
    let iconExpand: UIImage
    let iconShrink: UIImage
    let items: [SelectorItem]
    let musicResource: MusicResource
    var audioVolume: Float = 1 {
        didSet {
            NotificationCenter.default.post(name: Notification.audioUpdate, object: AudioUpdate(volume: audioVolume, musicResource: musicResource))
        }
    }

    init(with musicResource: MusicResource, items: [SelectorItem], audioVolume: Float ) {
        self.musicResource = musicResource
        iconExpand = musicResource.iconExpand
        iconShrink = musicResource.iconShrink
        self.audioVolume = audioVolume
        self.items = items
    }
}
