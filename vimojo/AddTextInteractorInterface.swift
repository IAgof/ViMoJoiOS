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
}

protocol AddTextInteractorDelegate {
    
}