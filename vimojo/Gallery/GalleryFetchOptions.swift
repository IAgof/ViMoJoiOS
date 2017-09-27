//
//  GalleryFetchOptions.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos

class GalleryFetchOptions: NSObject {
    func orderByCreationDate() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.predicate = NSPredicate(format: "mediaSubType = %d", PHAssetMediaSubtype.videoStreamed.rawValue)
        return fetchOptions
    }
    
}

