//
//  MusicListWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

let musicListViewControllerIdentifier = "MusicListViewController"

class MusicListWireframe {
    var rootWireframe : RootWireframe?
    var musicListViewController : MusicListViewController?
    var musicListPresenter : MusicListPresenter?
    var playerWireframe: PlayerWireframe?
    var editorRoomWireframe:EditingRoomWireframe?

    func presentMusicInterfaceFromWindow(_ window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentMusicListInterface(){
        let viewController = musicViewControllerFromStoryboard()
        
        guard let prevController = getVisibleViewController() else{
            return
        }
        prevController.show(viewController, sender: nil)
//        prevController.presentViewController(viewController, animated: true, completion: nil)
        
    }
    
    func musicViewControllerFromStoryboard() -> MusicListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: musicListViewControllerIdentifier) as! MusicListViewController
        
        viewController.eventHandler = musicListPresenter
        musicListViewController = viewController
        musicListPresenter?.delegate = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(musicListViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    func removeController(){
        musicListViewController?.dismiss(animated: true, completion: nil)
    }
    
    func presentEditor(){
        removeController()
        
        guard let wireframe = editorRoomWireframe else{
            return
        }
        wireframe.editingRoomViewController?.eventHandler?.pushEditor()
    }
    
    func getVisibleViewController() -> UIViewController? {
        
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        if rootViewController?.presentedViewController == nil {
            return rootViewController
        }
        
        if let presented = rootViewController?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return presented
        }
        return nil
    }
    
}
