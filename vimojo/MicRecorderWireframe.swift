//
//  MicRecorderWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

let micRecorderViewControllerIdentifier = "MicRecorderViewController"

class MicRecorderWireframe {
    var rootWireframe : RootWireframe?
    var micRecorderViewController : MicRecorderViewController?
    var micRecorderPresenter : MicRecorderPresenter?
    var playerWireframe: PlayerWireframe?
    var editorRoomWireframe:EditingRoomWireframe?
    
    func presentMusicInterfaceFromWindow(window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentMicRecorderInterface(){
        let viewController = musicViewControllerFromStoryboard()
        
        guard let prevController = getVisibleViewController() else{
            return
        }
        prevController.showViewController(viewController, sender: nil)
        //        prevController.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func musicViewControllerFromStoryboard() -> MicRecorderViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(micRecorderViewControllerIdentifier) as! MicRecorderViewController
        
        viewController.eventHandler = micRecorderPresenter
        micRecorderViewController = viewController
        micRecorderPresenter?.delegate = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(micRecorderViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func removeController(){
        micRecorderViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentEditor(){
        removeController()
        
        guard let wireframe = editorRoomWireframe else{
            return
        }
        wireframe.editingRoomViewController?.eventHandler?.pushEditor()
    }
    
    func getVisibleViewController() -> UIViewController? {
        
        let rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        if rootViewController?.presentedViewController == nil {
            return rootViewController
        }
        
        if let presented = rootViewController?.presentedViewController {
            if presented.isKindOfClass(UINavigationController) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKindOfClass(UITabBarController) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return presented
        }
        return nil
    }
    
}
