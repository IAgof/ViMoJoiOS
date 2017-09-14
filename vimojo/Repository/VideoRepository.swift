//
//  VideoRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import RealmSwift

public protocol VideoRepository: Repository {
    typealias T = Video

    func update(item: Video, realmProject: RealmProject)
    func getVideos()->Results<RealmVideo>
    func removeAllVideos()
}
