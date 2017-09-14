//
//  SaveVideosFromGalleryInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 3/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SaveVideosFromGalleryInterface {
    func saveVideos(_ URLs: [URL])
    func setDelegate(_ delegate: SaveVideosFromGalleryDelegate)
}

protocol SaveVideosFromGalleryDelegate {
    func saveVideosDone()
}
