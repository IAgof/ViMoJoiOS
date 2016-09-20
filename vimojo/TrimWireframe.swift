//
//  TrimWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer
import VideonaTrim

let trimViewControllerIdentifier = "TrimViewController"

class TrimWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var trimViewController : TrimViewController?
    var trimPresenter : TrimPresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    var prevController:UIViewController?
    
    func presentTrimInterfaceFromWindow(window: UIWindow) {
        let viewController = trimViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentTrimInterfaceFromViewController(prevController:UIViewController,
                                                videoSelected:Int)
    {
        let viewController = trimViewControllerFromStoryboard()
        
        self.prevController = prevController
        trimPresenter?.setVideoSelectedIndex(videoSelected)
        viewController.wireframe = self
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func trimViewControllerFromStoryboard() -> TrimViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(trimViewControllerIdentifier) as! TrimViewController
        
        viewController.eventHandler = trimPresenter
        trimViewController = viewController
        trimPresenter?.delegate = viewController
        
        trimViewController?.playerHandler = playerWireframe?.getPlayerPresenter()
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(trimViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func goPrevController(){
        trimViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentExpandPlayer(){
        if let controller = trimViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
}