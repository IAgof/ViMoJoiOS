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
			PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: ClipsAlbum.albumName)   // create an asset collection with the album name
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
		let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

		if let _: AnyObject = collection.firstObject {
			return collection.firstObject
		}
		return nil
	}

	var savedLocalIdentifier: String?

	func saveVideo(_ clipPath: URL, project: Project, completion:@escaping (Bool, URL?) -> Void) {
		if assetCollection == nil {
			return
		}

		PHPhotoLibrary.shared().performChanges({

			guard let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: clipPath) else {return}
			guard let assetPlaceHolder = assetChangeRequest.placeholderForCreatedAsset  else {return}

			self.savedLocalIdentifier = assetPlaceHolder.localIdentifier

			let albumChangeRequest = PHAssetCollectionChangeRequest(for: self.assetCollection)
			let enumeration: NSArray = [assetPlaceHolder]
			albumChangeRequest!.addAssets(enumeration)
		}, completionHandler: {
			saved, _ in

			if saved {
				if let localIdentifier = self.savedLocalIdentifier {
					self.setVideoUrlParameters(clipPath,
											   localIdentifier,
											   project: project,
											   completion: { videoURL in
												completion(true, videoURL)
					})
					Utils().removeFileFromURL(clipPath)
				}
			} else {
				completion(false, nil)
			}
		})
	}

	func removeVideoFromDocuments(_ clipPath: URL) {

	}

	func setVideoUrlParameters(_ clipPath: URL,
							   _ localIdentifier: String,
							   project: Project,
							   completion: @escaping (URL) -> Void) {

		let videoList = project.getVideoList()

		for video in videoList {
			if (video.getInternalFileURL() == clipPath) {
				let phFetchAsset = PHAsset.fetchAssets(withLocalIdentifiers: [localIdentifier], options: nil)
				let phAsset = phFetchAsset[0]
				PHImageManager.default().requestAVAsset(forVideo: phAsset, options: nil, resultHandler: {
					avasset, _, _ in
					if let asset = avasset as? AVURLAsset {
						video.videoURL = asset.url
						video.mediaRecordedFinished()
						VideoRealmRepository().add(item: video)
						ViMoJoTracker.sharedInstance.sendVideoRecordedTracking(video.getDuration())
						project.updateModificationDate()
						ProjectRealmRepository().update(item: project)
						completion(asset.url)
					}
				})
			}
		}
	}
}
