//
//  AddFilterToVideoPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

protocol AddFilterToVideoPresenterInterface {
    func viewDidLoad()
    func viewWillAppear()
    
    func pushOptions()
    
    func parameterSliderValueChanged(sliderValue value:Float,parameterType type:VideoParameterSlider)
    func setDefaultParameters()
    func playerIsReady()
    func selectedFilter(index:Int)
}

protocol AddFilterToVideoPresenterDelegate {
    func setFilters(filters:[FilterCollectionViewModel])
    func deselectFilter(inPosition:Int)
    func setUpView(withParameters parameters:ProjectParametersViewModel)
    func scrollToNextElement() 
}
