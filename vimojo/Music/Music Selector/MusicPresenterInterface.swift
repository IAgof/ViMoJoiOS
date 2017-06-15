//
//  MusicPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

protocol MusicPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func viewDidAppear()
    
    func expandPlayer()
    func updatePlayerLayer()
    
    func pushMusicHandler()
    func pushMicHandler()
    func pushOptions()
}

typealias Action = (Void) -> (Void)

protocol Item {
    var icon: UIImage{ get }
}

enum MusicItem: Item {
    case music(music: Music)
    case mic    
    case originalAudio(videos: [Video])
    
    var icon: UIImage{
        switch self {
        case .mic: return #imageLiteral(resourceName: "activity_edit_audio_voiceover_expand")
        case .music: return #imageLiteral(resourceName: "activity_edit_audio_music_expand")
        case .originalAudio: return #imageLiteral(resourceName: "activity_edit_audio_sound_expand")
        }
    }
    
    var cellItems: [SelectorItem]{
        switch <#value#> {
        case <#pattern#>:
            <#code#>
        default:
            <#code#>
        }
    }
}

class FloatingItem {
    
    
    let item: Item
    let action: Action
    
    init(item: Item, action: @escaping Action = {} ) {
        self.item = item
        self.action = action
    }
}

protocol MusicPresenterDelegate {
    var audios: [MusicSelectorCellViewModel] {get set}
    var floatingItems: [FloatingItem] { get set }
    func bringToFrontExpandPlayerButton()
}
