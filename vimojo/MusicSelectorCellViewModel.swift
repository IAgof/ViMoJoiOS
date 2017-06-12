//
//  MusicSelectorCellViewModel.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

typealias DefaultAction = () -> ()

struct MusicSelectorCellViewModel {    
    let icon: UIImage
    let action: DefaultAction
    
    init(with musicResource: MusicResource, action: @escaping DefaultAction ) {
        icon = musicResource.icon
        self.action = action
    }
    
}
