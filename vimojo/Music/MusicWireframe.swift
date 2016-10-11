//
//  MusicWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

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
    
    var prevController:UIViewController?
    
    func presentMusicInterfaceFromWindow(window: UIWindow) {
        let viewController = musicViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentMusicInterfaceFromViewController(prevController:UIViewController){
        let viewController = musicViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func musicViewControllerFromStoryboard() -> MusicViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(musicViewControllerIdentifier) as! MusicViewController
        
        viewController.eventHandler = musicPresenter
        musicViewController = viewController
        musicPresenter?.delegate = viewController
        musicPresenter?.controller = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(musicViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
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
        wireframe.editingRoomViewController?.eventHandler?.pushEditor()
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
}