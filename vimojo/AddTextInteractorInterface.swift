//
//  AddTextInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

protocol AddTextInteractorInterface {
    func setVideoPosition(position: Int) 
    func setUpComposition(completion:(AVMutableComposition)->Void)
    
    func getVideoParams()
    func setParametersToVideo(text:String,
                              position:Int)
    func exportVideoWithText(text:String)
}

protocol AddTextInteractorDelegate {
    func setVideoParams(text:String,
                        position:Int)
    
    func updateVideoList()
}