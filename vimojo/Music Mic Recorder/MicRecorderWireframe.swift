//
//  MicRecorderWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

let micRecorderViewControllerIdentifier = "MicRecorderViewController"

class MicRecorderWireframe {
    var rootWireframe: RootWireframe?
    var micRecorderViewController: MicRecorderViewController?
    var micRecorderPresenter: MicRecorderPresenter?
    var playerWireframe: PlayerWireframe?
    var editorRoomWireframe: EditingRoomWireframe?

    func presentMusicInterfaceFromWindow(_ window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()

        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }

    func presentMicRecorderInterface() {
        let viewController = musicViewControllerFromStoryboard()

        guard let prevController = UIApplication.topViewController() else {
            return
        }
        prevController.show(viewController, sender: nil)
    }

    func musicViewControllerFromStoryboard() -> MicRecorderViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: micRecorderViewControllerIdentifier) as! MicRecorderViewController

        viewController.eventHandler = micRecorderPresenter
        micRecorderViewController = viewController
        micRecorderPresenter?.delegate = viewController

        return viewController
    }

    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(micRecorderViewController!)
    }

    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }

    func removeController() {
        micRecorderViewController?.navigationController?.popViewController()
    }

    func presentEditor() {
        if configuration.VOICE_OVER_FEATURE {
            removeController()
        }

        guard let wireframe = editorRoomWireframe else {return}

        wireframe.editingRoomViewController?.selectedIndex = 0
    }
}
