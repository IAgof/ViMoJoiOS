//
//  AddTextPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

protocol AddTextPresenterInterface {
    func viewDidLoad()
    func viewWillDissappear()
    func pushCancelHandler()
    func pushAcceptHandler()
    func pushBack()
    func expandPlayer()
    
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
}