//
//  FilterProvider.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 15/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

class FilterProvider {
    static func getFilters()->[FilterFoundModel]{
        let filterSepia = FilterFoundModel(filterName: "CISepiaTone", filterImage: nil,displayName:"Sepia")
        let filterVibrance = FilterFoundModel(filterName: "CIVibrance", filterImage: nil,displayName:"Vibrance")
        let filterPhotoEffectInstant = FilterFoundModel(filterName: "CIPhotoEffectInstant", filterImage: nil,displayName:"Photo Instant")
        let filterPhotoEffectMono = FilterFoundModel(filterName: "CIPhotoEffectMono", filterImage: nil,displayName:"Mono")
        let filterPhotoEffectNoir = FilterFoundModel(filterName: "CIPhotoEffectNoir", filterImage: nil,displayName:"Noir")
        let filterPhotoEffectProcess = FilterFoundModel(filterName: "CIPhotoEffectProcess", filterImage: nil,displayName:"Photo process")
        
        var filters = Array<FilterFoundModel>()
        filters.append(filterSepia)
        filters.append(filterVibrance)
        filters.append(filterPhotoEffectInstant)
        filters.append(filterPhotoEffectMono)
        filters.append(filterPhotoEffectNoir)
        filters.append(filterPhotoEffectProcess)
        
        return filters
    }
}
