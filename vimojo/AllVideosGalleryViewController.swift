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
        cellColor = configuration.mainColor
    }
    
    override func fetchVideos() {
        //fetch the photos from collection
        self.navigationController?.hidesBarsOnTap = false
        let fetchOptions = GalleryFetchOptions().orderByCreationDate()
        self.videosAsset = PHAsset.fetchAssets(with: .video, options: fetchOptions)
    }
}
