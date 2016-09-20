//
//  MusicViewInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer

protocol MusicViewInterface:ViMoJoInterface {
    func cameFromFullScreenPlayer(playerView:PlayerView)
    func bringToFrontExpandPlayerButton()
}