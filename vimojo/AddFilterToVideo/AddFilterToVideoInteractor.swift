//
//  AddFilterToVideoInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class AddFilterToVideoInteractor {
    var delegate:AddFilterToVideoInteractorDelegate?
    var project:Project
    var filtersFound:[FilterFoundModel] = []

    init(project:Project) {
        self.project = project
    }

}

extension AddFilterToVideoInteractor:AddFilterToVideoInteractorInterface{
    func changeVideoParameter(paramValue value:Float,parameterType type:VideoParameterSlider){
        let value = value / 100
        
        switch type {
        case .brightness:
            project.videoOutputParameters.brightness = NSNumber(value: value)
            break
        case .contrast:
            project.videoOutputParameters.contrast = NSNumber(value: value)
            break
        case .exposure:
            project.videoOutputParameters.exposure = NSNumber(value: value)
            break
        case .saturation:
            project.videoOutputParameters.saturation = NSNumber(value: value)
            break
        }
        getVideoComposition()
    }

    func getFilters() {
        filtersFound =  FilterProvider.getFilters()
        
        let thumbImage = getVideoThumbnail()
        for  i in 0...(filtersFound.count - 1){
            filtersFound[i].filterImage = thumbImage
        }
        
        delegate?.filtersFound(filters:filtersFound)
    }
    
    func findFilterPositionInList()->Int?{
        var count = 0
        guard let projectFilter = project.videoFilter else {return nil}
        for filter in filtersFound{
            if filter.filterName == projectFilter.name{
                return count
            }
            count += 1
        }
        return nil
    }
    
    func getProjectParameters() {
        let parameters = project.videoOutputParameters
        let filterPosition = findFilterPositionInList()
        
        let projectParametersViewModel = ProjectParametersViewModel(brightness:Float(parameters.brightness),
                                                                    contrast: Float(parameters.contrast),
                                                                    exposure: Float(parameters.exposure),
                                                                    saturation: Float(parameters.saturation),
                                                                    filterSelectedPosition:filterPosition)
        delegate?.setUpView(withParameters: projectParametersViewModel)
    }
    
    func setFilterInPosition(position: Int) {
        if filtersFound.indices.contains(position){
            let filterName = filtersFound[position].filterName
            let filter = CIFilter(name: filterName)!
            
            project.videoFilter = filter
            getVideoComposition()
        }
    }
    
    func removeFilter() {
        project.videoFilter = nil
        getVideoComposition()
    }
    
    func getVideoThumbnail()->UIImage{
        guard let videoURL = project.getVideoList().first?.videoURL else{
            return UIImage(named: "activity_project_gallery_no_videos")!
        }
        
        let asset = AVAsset(url: videoURL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 1)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            print("error")
        }
        return UIImage(named: "activity_project_gallery_no_videos")!
    }
    
    func getVideoComposition() {
        var actualComposition = GetActualProjectAVCompositionUseCase().getComposition(project: project)
        let layer = GetActualProjectTextCALayerAnimationUseCase().getCALayerAnimation(project: project)
        actualComposition.layerAnimation = layer
        delegate?.setVideoComposition(actualComposition)
    }
}
