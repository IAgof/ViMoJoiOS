//
//  EditorWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//
import Foundation
import UIKit
import VideonaPlayer

let editorViewControllerIdentifier = "EditorViewController"

class EditorWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var editorViewController : EditorViewController?
    var editorPresenter : EditorPresenter?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?
    var prevController:UIViewController?

    var trimWireframe:TrimWireframe?
    var duplicateWireframe:DuplicateWireframe?
    var splitWireframe:SplitWireframe?
    var addTextWireframe:AddTextWireframe?

    func presentEditorInterfaceFromWindow(window: UIWindow) {
        let viewController = editorViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentEditorInterfaceFromViewController(prevController:UIViewController){
        let viewController = editorViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func editorViewControllerFromStoryboard() -> EditorViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(editorViewControllerIdentifier) as! EditorViewController
        
        viewController.eventHandler = editorPresenter
        editorViewController = viewController
        editorPresenter?.controller = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(editorViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func presentTrimController(videoSelected:Int){
        trimWireframe?.presentTrimInterfaceFromViewController(editorViewController!,
                                                              videoSelected:videoSelected)
    }
    
    func presentDuplicateController(videoSelected:Int){
        duplicateWireframe?.presentDuplicateInterfaceFromViewController(editorViewController!,
                                                              videoSelected:videoSelected)
    }
    
    func presentSplitController(videoSelected:Int){
        splitWireframe?.presentSplitInterfaceFromViewController(editorViewController!,
                                                                videoSelected: videoSelected)
    }
    
    func presentAddTextController(videoSelected:Int){
        addTextWireframe?.presentAddTextInterfaceFromViewController(editorViewController!,
                                                                videoSelected: videoSelected)
    }
    
    func presentExpandPlayer(){
        if let controller = editorViewController{
            if let player = playerWireframe?.presentedView{
                fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController(controller,
                                                                                     playerView:player)
            }
        }
    }
}