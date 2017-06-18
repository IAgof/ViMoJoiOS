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

typealias DefaultAction = () -> ()

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

struct MusicSelectorCellViewModel {
    let icon: UIImage
    let items: [SelectorItem]
    
    init(with musicResource: MusicResource, items: [SelectorItem] ) {
        icon = musicResource.icon
        self.items = items
    }
}
