//
//  MusicWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

let musicViewControllerIdentifier = "MusicViewController"

class MusicWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var musicViewController : MusicViewController?
    var musicPresenter : MusicPresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?
    var editorRoomWireframe:EditingRoomWireframe?
    
    var musicListWireframe:MusicListWireframe?
    var micRecorderWireframe:MicRecorderWireframe?
    var editingRoomWireframe:EditingRoomWireframe?

    var prevController:UIViewController?
    
    func presentMusicInterfaceFromWindow(_ window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentMusicInterfaceFromViewController(_ prevController:UIViewController){
        let viewController = musicViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func musicViewControllerFromStoryboard() -> MusicViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: musicViewControllerIdentifier) as! MusicViewController
        
        viewController.eventHandler = musicPresenter
        musicViewController = viewController
        musicPresenter?.delegate = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(musicViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    func presentExpandPlayer(){
        if let controller = musicViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
    
    func presentEditor(){
        guard let wireframe = editorRoomWireframe else{
            return
        }
        if let controller = musicViewController{
            wireframe.presentEditingRoomInterfaceFromViewController(controller)
        }
    }
    
    func presenterMusicListView(){
        guard let wireframe = musicListWireframe else{
            return
        }
        wireframe.presentMusicListInterface()
    }
    
    func presenterMicRecorderView(){
        guard let wireframe = micRecorderWireframe else{
            return
        }
        wireframe.presentMicRecorderInterface()
    }
    
    func presentSettings(){
        editingRoomWireframe?.navigateToSettings()
    }
}
