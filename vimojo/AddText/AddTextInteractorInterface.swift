//
//  AddTextInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation
import VideonaProject

protocol AddTextInteractorInterface {
    func setVideoPosition(_ position: Int)
    func setUpComposition(_ completion: (VideoComposition) -> Void)

    func getVideoParams()
    func setParametersToVideo(_ text: String,
                              position: Int)

    func getLayerToPlayer(_ text: String)
    func setAlignment(_ alignment: CATextLayerAttributes.VerticalAlignment,
                      text: String)
}

protocol AddTextInteractorDelegate {
    func setVideoParams(_ text: String,
                        position: Int)

    func updateVideoList()
    func setAVSyncLayerToPlayer(_ layer: CALayer)
}
