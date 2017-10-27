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
import AVFoundation
import Photos

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
	
	func pushAddFloating()
	func addSelection(selection: String)
}

typealias Action = () -> Void

protocol Item {
    var icon: UIImage { get }
}

extension CMTimeRange {
    init(start: Double, end: Double) {
        let startTime = CMTimeMakeWithSeconds(start, 600)
        let endTime = CMTimeMakeWithSeconds(end, 600)
        self.init(start: startTime, end: endTime)
    }
}

enum FloatingItemFactory: Item {
    case music
    case mic
    case originalAudio

    var icon: UIImage {
        switch self {
        case .mic: return #imageLiteral(resourceName: "activity_edit_audio_voiceover_expand")
        case .music: return #imageLiteral(resourceName: "activity_edit_audio_music_expand")
        case .originalAudio: return #imageLiteral(resourceName: "activity_edit_audio_sound_expand")
        }
    }
}

protocol MusicPresenterDelegate {
    var audios: [MusicSelectorCellViewModel] {get set}
    func bringToFrontExpandPlayerButton()
	func createAlertWithAddOptions(title: String,
	                               options: [String])
}
