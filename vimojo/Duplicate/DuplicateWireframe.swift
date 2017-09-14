//
//  DuplicateWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

let duplicateViewControllerIdentifier = "DuplicateViewController"

class DuplicateWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var duplicateViewController: DuplicateViewController?
    var duplicatePresenter: DuplicatePresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    var prevController: UIViewController?

    func presentDuplicateInterfaceFromWindow(_ window: UIWindow) {
        let viewController = duplicateViewControllerFromStoryboard()

        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }

    func presentDuplicateInterfaceFromViewController(_ prevController: UIViewController,
                                                videoSelected: Int) {
        let viewController = duplicateViewControllerFromStoryboard()

        self.prevController = prevController
        duplicatePresenter?.videoSelectedIndex = videoSelected
        prevController.show(viewController, sender: nil)
    }

    func duplicateViewControllerFromStoryboard() -> DuplicateViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: duplicateViewControllerIdentifier) as! DuplicateViewController

        viewController.eventHandler = duplicatePresenter
        duplicateViewController = viewController
        duplicatePresenter?.delegate = viewController
        viewController.wireframe = self
        viewController.playerHandler = playerWireframe?.getPlayerPresenter()

        return viewController
    }

    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(duplicateViewController!)
    }

    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }

    func goPrevController() {
        self.duplicateViewController?.navigationController?.popViewController()
    }

    func presentExpandPlayer() {
        if let controller = duplicateViewController {
            if let player = playerWireframe?.presentedView {
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
}
