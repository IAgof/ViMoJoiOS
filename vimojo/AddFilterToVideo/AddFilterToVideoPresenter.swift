//
//  AddFilterToVideoPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class AddFilterToVideoPresenter{
    var interactor:AddFilterToVideoInteractorInterface?
    var delegate:AddFilterToVideoPresenterDelegate?
    var wireframe:AddFilterToVideoWireframe?
    var playerPresenter:PlayerPresenterInterface?
    
    var lastSelectedFilter:Int?
    
}

extension AddFilterToVideoPresenter:AddFilterToVideoPresenterInterface{
    
    func viewDidLoad() {
        
    }
    
    func viewWillAppear() {
        wireframe?.presentPlayerInterface()

        interactor?.getVideoComposition()
        interactor?.getFilters()
        interactor?.getProjectParameters()
    }
    
    func pushOptions() {
//        wireframe?.presentSettings()
    }
    
    func playerIsReady() {
        playerPresenter?.seekToTime(1)
    }
    func parameterSliderValueChanged(sliderValue value: Float, parameterType type: VideoParameterSlider) {
        interactor?.changeVideoParameter(paramValue: value, parameterType: type)
    }
    
    func selectedFilter(index: Int) {
        if index == lastSelectedFilter {
            delegate?.deselectFilter(inPosition: index)
            
            lastSelectedFilter = nil
        }else{
            interactor?.setFilterInPosition(position: index)
            
            lastSelectedFilter = index
        }
    }
}

extension AddFilterToVideoPresenter:AddFilterToVideoInteractorDelegate{
    func setVideoComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)        
    }
    
    func filtersFound(filters: [FilterFoundModel]) {
        var filtersViewModel = Array<FilterCollectionViewModel>()
        
        for filterFound in filters{
            if let image = filterFound.filterImage{
                filtersViewModel.append(FilterCollectionViewModel(image: image,
                                                                  name:filterFound.filterName))
            }else{
                filtersViewModel.append(FilterCollectionViewModel(image: UIImage(),
                                                                  name:filterFound.filterName))
            }
        }
        
        delegate?.setFilters(filters: filtersViewModel)
    }
    
    func setUpView(withParameters parameters: ProjectParametersViewModel) {
        delegate?.setUpView(withParameters: parameters)
    }
}
