//
//  Audio4VideoViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 18/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

class Audio4VideoViewController: ViMoJoController, Audio4VideoPresenterDelegate {
    var eventHandler: Audio4VideoPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    
}
