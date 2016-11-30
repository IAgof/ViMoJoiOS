//
//  ExportedAlbum.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos
import VideonaProject

class ExportedAlbum: NSObject {
    static let albumName = "ViMoJo Export"
    static let sharedInstance = ExportedAlbum()
    
    var assetCollection: PHAssetCollection!
    var savedLocalIdentifier:String?

    override init() {
        super.init()
        
        if let assetCollection = fetchAssetCollectionForAlbum() {
            self.assetCollection = assetCollection
            return
        }
        
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                status
            })
        }
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            self.createAlbum()
        } else {
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(_ status: PHAuthorizationStatus) {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            // ideally this ensures the creation of the photo album even if authorization wasn't prompted till after init was done
            print("trying again to create the album")
            self.createAlbum()
        } else {
            print("should really prompt the user to let them know it's failed")
        }
    }
    
    func createAlbum() {
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: ExportedAlbum.albumName)   // create an asset collection with the album name
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
        fetchOptions.predicate = NSPredicate(format: "title = %@", ExportedAlbum.albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            return collection.firstObject! as PHAssetCollection
        }
        return nil
    }
    
    func saveVideo(_ clipPath:URL,completion:@escaping (URL)->Void) {
        if assetCollection == nil {
            return                          // if there was an error upstream, skip the save
        }
        
        PHPhotoLibrary.shared().performChanges({
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: clipPath)
            let assetPlaceHolder = assetChangeRequest!.placeholderForCreatedAsset
            self.savedLocalIdentifier = assetPlaceHolder?.localIdentifier
            
            let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
            let enumeration: NSArray = [assetPlaceHolder!]
            albumChangeRequest!.addAssets(enumeration)
        }, completionHandler: {
            saved, error in
            
            if saved{
                if let localIdentifier = self.savedLocalIdentifier{
                    self.getVideoUrlFromIdentifier(localIdentifier, completion: {
                        videoURL in
                        completion(videoURL)
                    })
                    Utils().removeFileFromURL(clipPath)
                }
            }
        })
    }
    
    func getVideoUrlFromIdentifier(_ localIdentifier:String,completion:@escaping (URL)->Void){
        let phFetchAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
        let phAsset = phFetchAsset[0]
        PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil, resultHandler: {
            avasset,audiomix,info in
            if let asset = avasset as? AVURLAsset{
                completion(asset.url)
            }
        })
    }

}
