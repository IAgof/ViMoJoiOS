//
//  ClipsAlbum.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import Photos

class ClipsAlbum: NSObject {
    static let albumName = "ViMoJo Clips"
    static let sharedInstance = ClipsAlbum()
    
    var assetCollection: PHAssetCollection!
    
    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.Authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(ClipsAlbum.albumName)   // create an asset collection with the album name
        }) { success, error in
            if success {
                self.assetCollection = self.fetchAssetCollectionForAlbum()
            } else {
                print("error \(error)")
            }
        }
    }
    
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", ClipsAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject as! PHAssetCollection
        }
        return nil
    }
    
    var savedLocalIdentifier:String?
    
    func saveVideo(clipPath:NSURL,project:Project) {
        if assetCollection == nil {
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            
            guard let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideoAtFileURL(clipPath) else {return}
            guard let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset  else {return}
            
            self.savedLocalIdentifier = assetPlaceHolder.localIdentifier
            
            let albumChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: self.assetCollection)
            albumChangeRequest!.addAssets([assetPlaceHolder])
           
            }, completionHandler: {
                saved, error in
                
                if saved{
                    if let localIdentifier = self.savedLocalIdentifier{
                        self.setVideoUrlParameters(localIdentifier,
                            project: project)
                    }
                }
        })
    }
    
    func setVideoUrlParameters(localIdentifier:String,
                               project:Project){
        
        if let video = project.getVideoList().last{
            let phFetchAsset = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: nil)
            let phAsset = phFetchAsset[0] as! PHAsset
            PHImageManager.defaultManager().requestAVAssetForVideo(phAsset, options: nil, resultHandler: {
                avasset,audiomix,info in
                if let asset = avasset as? AVURLAsset{
                    video.videoURL = asset.URL
                }
            })
        }
    }
}