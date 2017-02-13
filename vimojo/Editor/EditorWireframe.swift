//
//  EditorWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//
import Foundation
import UIKit
import VideonaProject

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
    var editingRoomWireframe:EditingRoomWireframe?
    
    func presentEditorInterfaceFromWindow(_ window: UIWindow) {
        let viewController = editorViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentEditorInterfaceFromViewController(_ prevController:UIViewController){
        let viewController = editorViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func editorViewControllerFromStoryboard() -> EditorViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: editorViewControllerIdentifier) as! EditorViewController
        
        viewController.eventHandler = editorPresenter
        editorViewController = viewController
        editorPresenter?.delegate = viewController
        
        return viewController
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(editorViewController!)
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    func presentDuplicateController(_ videoSelected:Int){
        duplicateWireframe?.presentDuplicateInterfaceFromViewController(editorViewController!,
                                                              videoSelected:videoSelected)
    }
    
    func presentSplitController(_ videoSelected:Int){
        splitWireframe?.presentSplitInterfaceFromViewController(editorViewController!,
                                                                videoSelected: videoSelected)
    }
    
    func presentAddTextController(_ videoSelected:Int){
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
    
    func presentGallery(){
        editingRoomWireframe?.navigateToGallery()
    }
    
    func presentRecorder(){
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        editingRoomWireframe?.navigateToRecorder()
    }
    
    func presentSettings(){
        editingRoomWireframe?.navigateToSettings()
    }
    
    func presentGoToRecordOrGallery(){
        editingRoomWireframe?.navigateToRecordOrGallery()
    }
}
