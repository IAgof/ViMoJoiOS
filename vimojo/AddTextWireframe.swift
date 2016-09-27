//
//  AddTextWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import VideonaPlayer

let addTextViewControllerIdentifier = "AddTextViewController"

class AddTextWireframe : NSObject {
    
    var rootWireframe : RootWireframe?
    var addTextViewController : AddTextViewController?
    var addTextPresenter : AddTextPresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    var prevController:UIViewController?
    
    func presentAddTextInterfaceFromViewController(prevController:UIViewController,
                                                   videoSelected:Int)
    {
        let viewController = addTextViewControllerFromStoryboard()
        
        self.prevController = prevController
        addTextPresenter?.videoSelectedIndex = videoSelected
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func addTextViewControllerFromStoryboard() -> AddTextViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(addTextViewControllerIdentifier) as! AddTextViewController
        
        viewController.eventHandler = addTextPresenter
        addTextViewController = viewController
        addTextPresenter?.delegate = viewController
        viewController.wireframe = self
        viewController.playerHandler = playerWireframe?.getPlayerPresenter()

        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func presentExpandPlayer(){
        if let controller = addTextViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(addTextViewController!)
    }
    
    func goPrevController(){
        addTextViewController?.dismissViewControllerAnimated(true, completion: nil)
//        addTextViewController?.navigationController?.popToViewController(prevController!, animated: true)
    }
}