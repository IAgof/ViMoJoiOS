//
//  CustomClipsGalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideonaProject


class CustomClipsGalleryViewController: VideosGalleryViewController {
    let albumExportedName = "ViMoJo Clips"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cellColor = configuration.mainColor
    }
    
    override func fetchVideos() {
        albumName = albumExportedName
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        var assetCollection: PHAssetCollection = PHAssetCollection()
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            assetCollection = first_Obj as! PHAssetCollection
            
            let videoFetchOptions = GalleryFetchOptions().orderByCreationDate()
            self.videosAsset = PHAsset.fetchAssets(in: assetCollection, options: videoFetchOptions)
            
            
            if let photoCnt = self.videosAsset?.count{
                if(photoCnt == 0){
                    self.noPhotosLabel.isHidden = false
                }else{
                    self.noPhotosLabel.isHidden = true
                }
            }
        }
    }
}
