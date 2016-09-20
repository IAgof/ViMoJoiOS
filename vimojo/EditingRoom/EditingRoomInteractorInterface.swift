//
//  EditingRoomInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public protocol EditingRoomInteractorInterface{
    func getProject()->Project
    func getNumberOfClips()->Int
}