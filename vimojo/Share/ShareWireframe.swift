//
//  ShareWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

let shareViewControllerIdentifier = "ShareViewController"

class ShareWireframe : NSObject {
    
    var rootWireframe : RootWireframe?
    var shareViewController : ShareViewController?
    var sharePresenter : SharePresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?
    var editingRoomWireframe:EditingRoomWireframe?

    var prevController:UIViewController?

    func presentShareInterfaceFromWindow(_ window: UIWindow) {
        let viewController = shareViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func shareViewControllerFromStoryboard() -> ShareViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: shareViewControllerIdentifier) as! ShareViewController
        
        viewController.eventHandler = sharePresenter
        shareViewController = viewController
        sharePresenter?.delegate = viewController

        return viewController
    }
    
    func presentExpandPlayer(){
        if let controller = shareViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(shareViewController!)
    }
    
    func goPrevController(){
        if prevController!.isKind(of: RecordController.self) {
            (prevController as! RecordController).resetView()
        }
        
        shareViewController?.navigationController?.popToViewController(prevController!, animated: true)
    }
    
    func presentSettings(){
        editingRoomWireframe?.navigateToSettings()
    }
    
    func presentEditor(){
        editingRoomWireframe?.editingRoomViewController?.selectedIndex = 0
    }
}
