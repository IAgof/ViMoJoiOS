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
    let audio4VideonaViewControllerIdentifier = "Audio4VideoViewController"

    var rootWireframe : RootWireframe
    var presenter: Audio4VideoPresenter = Audio4VideoPresenter()
    var interactor: Audio4VideoInteractor = Audio4VideoInteractor()
    var playerPresenter: PlayerPresenterInterface
    var playerWireframe: PlayerWireframe?
    var controller: Audio4VideoViewController?
    var mainStoryboard: UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    init(rootWireframe: RootWireframe,
         playerPresenter: PlayerPresenterInterface,
         playerWireframe: PlayerWireframe? ,
         project: Project,
         video: Video) {
        self.rootWireframe = rootWireframe
        self.playerPresenter = playerPresenter
        self.playerWireframe = playerWireframe
        let storyboard = mainStoryboard
        self.controller = storyboard.instantiateViewController(withIdentifier: audio4VideonaViewControllerIdentifier) as? Audio4VideoViewController
        

        configure(with: video, project: project)
    }
    
    func configure(with video: Video, project: Project){
        controller?.eventHandler = presenter
        presenter.delegate = controller
        presenter.interactor = interactor
        presenter.playerPresenter = playerPresenter
        presenter.wireframe = self
        interactor.setup(delegate: presenter, project: project, video: video)
    }
    
    func presentPlayerInterface() {
        guard let controller = self.controller , let playerWireframe = playerWireframe else{ return }
        playerWireframe.presentPlayerInterfaceFromViewController(controller)
    }
    
    func dissmiss(){
        _ = controller?.navigationController?.popViewController(animated: true)
    }
}
