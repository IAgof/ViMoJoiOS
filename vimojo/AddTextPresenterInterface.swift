//
//  AddTextPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaPlayer
import VideonaProject

protocol AddTextPresenterInterface {
    func viewDidLoad()
    func viewWillDissappear()
    func pushCancelHandler()
    func pushAcceptHandler()
    func pushBack()
    func expandPlayer()
    
    func topButtonPushed()
    func midButtonPushed()
    func bottomButtonPushed()
    
    func textHasChanged(_ text:String)
}

protocol AddTextPresenterDelegate {
    func bringToFrontExpandPlayerButton()
    
    func acceptFinished()
    func pushBackFinished()
    func expandPlayerToView()
    func setStopToVideo()
    func updatePlayerOnView(_ composition:VideoComposition)
    
    func setTextToEditTextField(_ text:String)
    func setSyncLayerToPlayer(_ layer:CALayer)
    
    func setSelectedTopButton(_ state:Bool)
    func setSelectedMidButton(_ state:Bool)
    func setSelectedBottomButton(_ state:Bool)
}
