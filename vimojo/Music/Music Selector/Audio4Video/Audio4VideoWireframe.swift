//
//  Audio4VideoWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class Audio4VideoWireframe {
    let audio4VideonaViewControllerIdentifier = "Audio4VideonaViewController"

    var rootWireframe : RootWireframe
    var presenter: Audio4VideoPresenter = Audio4VideoPresenter()
    var interactor: Audio4VideoInteractor = Audio4VideoInteractor()
    var playerPresenter: PlayerPresenter
    var controller: Audio4VideoViewController
    var mainStoryboard: UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    init(rootWireframe: RootWireframe,
         playerPresenter: PlayerPresenter,
         project: Project) {
        self.rootWireframe = rootWireframe
        self.playerPresenter = playerPresenter
        let storyboard = mainStoryboard
        self.controller = storyboard.instantiateViewController(withIdentifier: audio4VideonaViewControllerIdentifier) as! Audio4VideoViewController
        configure()
    }
    
    func configure(){
        controller.eventHandler = presenter
        presenter.delegate = controller
        presenter.interactor = interactor
        interactor.delegate = presenter
    }
}
