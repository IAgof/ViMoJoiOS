//
//  FullScreenPlayerWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 15/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer

let fullScreenPlayerViewControllerIdentifier = "FullScreenPlayerViewController"

protocol FullScreenWireframeDelegate {
    func cameFromFullScreenPlayer(playerView:PlayerView)
}

class FullScreenPlayerWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var fullScreenPlayerViewController: FullScreenPlayerViewController?
    var fullScreenPlayerPresenter: FullScreenPlayerPresenter?

    var prevController:UIViewController?

    func presentFullScreenPlayerFromViewController(prevController:UIViewController, playerView:PlayerView) {
        let viewController = fullScreenPlayerViewControllerFromStoryboard()

        viewController.playerView = playerView
        self.prevController = prevController

        prevController.showViewController(viewController, sender: nil)
    }

    func fullScreenPlayerViewControllerFromStoryboard() -> FullScreenPlayerViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(fullScreenPlayerViewControllerIdentifier) as! FullScreenPlayerViewController

        viewController.eventHandler = fullScreenPlayerPresenter
        fullScreenPlayerViewController = viewController
        fullScreenPlayerPresenter?.controller = viewController

        return viewController
    }

    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }

    func goPrevController(playerView:PlayerView){
        
        if let controller = prevController as? FullScreenWireframeDelegate{
            controller.cameFromFullScreenPlayer(playerView)
        }
        
        fullScreenPlayerViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}