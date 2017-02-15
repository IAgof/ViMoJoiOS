//
//  AddFilterToVideoInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

protocol AddFilterToVideoInteractorInterface {
    func changeVideoParameter(paramValue value:Float,parameterType type:VideoParameterSlider)
    func getVideoComposition()
    func getFilters()
    func getProjectParameters()
    func setFilterInPosition(position:Int)
    func removeFilter()
    func setDefaultParameters()
}

protocol AddFilterToVideoInteractorDelegate {
    func setVideoComposition(_ composition: VideoComposition)
    func filtersFound(filters:[FilterFoundModel])
    func setUpView(withParameters parameters:ProjectParametersViewModel)
}
