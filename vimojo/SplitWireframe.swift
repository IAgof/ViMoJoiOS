//
//  SplitWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import VideonaPlayer
import VideonaSplit

let splitViewControllerIdentifier = "SplitViewController"

class SplitWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var splitViewController : SplitViewController?
    var splitPresenter : SplitPresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    var prevController:UIViewController?
    
    func presentSplitInterfaceFromWindow(_ window: UIWindow) {
        let viewController = splitViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentSplitInterfaceFromViewController(_ prevController:UIViewController,
                                                     videoSelected:Int)
    {
        let viewController = splitViewControllerFromStoryboard()
        
        self.prevController = prevController
        splitPresenter?.videoSelectedIndex = videoSelected
        prevController.show(viewController, sender: nil)
    }
    
    func splitViewControllerFromStoryboard() -> SplitViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: splitViewControllerIdentifier) as! SplitViewController
        
        viewController.eventHandler = splitPresenter
        viewController.wireframe = self
        viewController.playerHandler = playerWireframe?.getPlayerPresenter()

        splitViewController = viewController
        splitPresenter?.delegate = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(splitViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        self.splitViewController?.navigationController?.popViewController()
    }
    
    func presentExpandPlayer(){
        if let controller = splitViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
}
