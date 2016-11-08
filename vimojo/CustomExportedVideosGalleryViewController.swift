//
//  CustomExportedVideosGalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 2/11/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideoGallery


class CustomExportedVideosGalleryViewController: VideosGalleryViewController {
    let albumExportedName = "ViMoJo Export"
   
    override func viewDidLoad() {
        super.viewDidLoad()
        cellColor = VIMOJO_RED_UICOLOR
    }
    
    override func fetchVideos() {
        albumName = albumExportedName
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection:PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        var assetCollection: PHAssetCollection = PHAssetCollection()
        
        if let first_Obj:AnyObject = collection.firstObject{
            //found the album
            assetCollection = first_Obj as! PHAssetCollection
            
            self.videosAsset = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: nil)
            
            
            if let photoCnt = self.videosAsset?.count{
                if(photoCnt == 0){
                    self.noPhotosLabel.hidden = false
                }else{
                    self.noPhotosLabel.hidden = true
                }
            }
        }
    }
}