//
//  MusicInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject
import AVFoundation

protocol MusicInteractorInterface {    
    var audios: [Audio]{get}
    func getVideoComposition()
}

protocol MusicInteractorDelegate {
    func setVideoComposition(_ composition: VideoComposition)
}
