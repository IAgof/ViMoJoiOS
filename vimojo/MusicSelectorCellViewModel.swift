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

struct SelectorItem {
    //TODO: this is not the correct place to be
    let image: UIImage
    let timeRange: CMTimeRange
}

struct MusicSelectorCellViewModel {
    let icon: UIImage
    let action: DefaultAction
    let items: [SelectorItem]
    
    init(with musicResource: MusicResource, action: @escaping DefaultAction, items: [SelectorItem] ) {
        icon = musicResource.icon
        self.action = action
        self.items = items
    }
}
