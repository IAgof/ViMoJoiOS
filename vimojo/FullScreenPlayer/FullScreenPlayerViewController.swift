//
//  FullScreenPlayerViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 15/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

class FullScreenPlayerViewController: ViMoJoController, FullScreenPlayerInterface {

    // MARK: - VIPER
    var eventHandler: FullScreenPlayerPresenterInterface?

    @IBOutlet weak var shrinkButton: UIButton!

    var playerView: PlayerView? {
        didSet {
            self.view.addSubview(playerView!)
            self.view.bringSubview(toFront: shrinkButton)
        }
    }

    @IBAction func pushShrinkButton(_ sender: AnyObject) {
        eventHandler?.onPushShrinkButton()
    }

    func getPlayerView() -> PlayerView {
        return playerView!
    }
}
