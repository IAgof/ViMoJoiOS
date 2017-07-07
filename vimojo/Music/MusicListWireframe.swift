//
//  MusicListWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

let musicListViewControllerIdentifier = "MusicListViewController"

class MusicListWireframe {
    var rootWireframe : RootWireframe?
    var musicListViewController : MusicListViewController?
    var musicListPresenter : MusicListPresenter?
    var playerWireframe: PlayerWireframe?
    var editorRoomWireframe:EditingRoomWireframe?
    var settingsWireframe:SettingsWireframe?
    
    func presentMusicInterfaceFromWindow(_ window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()

        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentMusicListInterface(){
        let viewController = musicViewControllerFromStoryboard()
        
        guard let prevController = UIApplication.topViewController() else{
            return
        }
        prevController.show(viewController, sender: nil)
        
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
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    func removeController(){
        musicListViewController?.navigationController?.popViewController()
    }
    
    func presentEditor(){
        if configuration.VOICE_OVER_FEATURE{
            removeController()
        }
        
        guard let wireframe = editorRoomWireframe else{return}
        
        wireframe.editingRoomViewController?.selectedIndex = 0
    }
    
    func presentSettings(){
        
        guard let prevController = UIApplication.topViewController() else{
            return
        }
        settingsWireframe?.presentSettingsInterfaceFromViewController(prevController)
    }
}