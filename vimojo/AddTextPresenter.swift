//
//  AddTextPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class AddTextPresenter: AddTextPresenterInterface,AddTextInteractorDelegate {
    var interactor:AddTextInteractorInterface?
    var delegate:AddTextPresenterDelegate?
    
    var videoSelectedIndex:Int!{
        didSet{
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    
    var isGoingToExpandPlayer = false

    func viewDidLoad() {
        
        delegate?.bringToFrontExpandPlayerButton()
        
        interactor?.setUpComposition({composition in
            self.delegate?.updatePlayerOnView(composition)
        })
    }
    
    func viewWillDissappear() {
        if !isGoingToExpandPlayer{
            
            delegate?.setStopToVideo()
        }
    }
    
    func pushAcceptHandler() {
//        interactor?.setParametersOnVideoSelectedOnProjectList(lowerValue,
//                                                              stopTime: upperValue)
        
        delegate?.acceptFinished()
    }
    
    func pushCancelHandler() {
        delegate?.pushBackFinished()
    }
    
    func pushBack() {
        delegate?.pushBackFinished()
    }
    
    func expandPlayer() {
        isGoingToExpandPlayer = true
        
        delegate?.expandPlayerToView()
    }
}