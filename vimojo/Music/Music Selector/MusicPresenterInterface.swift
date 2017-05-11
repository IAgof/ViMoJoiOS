//
//  MusicPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

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

protocol MusicPresenterDelegate {

}
