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
    
    func textHasChanged(text:String)

}

protocol AddTextPresenterDelegate {
    func bringToFrontExpandPlayerButton()
    
    func acceptFinished()
    func pushBackFinished()
    func expandPlayerToView()
    func setStopToVideo()
    func updatePlayerOnView(composition:AVMutableComposition)
    
    func setTextToPlayer(text:String)
    func setTextAlignment(alignment:VerticalAlignment)
    
    func setSelectedTopButton(state:Bool)
    func setSelectedMidButton(state:Bool)
    func setSelectedBottomButton(state:Bool)
}