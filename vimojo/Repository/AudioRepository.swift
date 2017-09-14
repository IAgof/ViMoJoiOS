//
//  AudioRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import RealmSwift

public protocol AudioRepository: Repository {
    typealias T = Audio

    func update(item: Audio, realmProject: RealmProject)
}
