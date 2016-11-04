//
//  AllVideosGalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 2/11/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideoGallery

class AllVideosGalleryViewController: VideosGalleryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        cellColor = VIMOJO_RED_UICOLOR
    }
    
    override func fetchVideos() {
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false
        self.videosAsset = PHAsset.fetchAssetsWithMediaType(.Video, options: nil)
    }
}