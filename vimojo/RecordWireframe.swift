//
//  RecordWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

let RecordViewControllerIdentifier = "RecordViewController"

class RecordWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var recordViewController : RecordController?
    var recordPresenter : RecordPresenter?
    
    var editorRoomWireframe: EditingRoomWireframe?

    func presentRecordInterfaceFromWindow(window: UIWindow) {
        let viewController = RecordViewControllerFromStoryboard()
        
        viewController.eventHandler = recordPresenter
        recordViewController = viewController
        recordPresenter?.delegate = viewController
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func setRecordViewControllerAsRootController() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let homeViewController =  RecordViewControllerFromStoryboard()
        let nav = UINavigationController(rootViewController: homeViewController)
        appdelegate.window!.rootViewController = nav
    }
    
    func presentRecordInterfaceFromViewController(prevController:UIViewController) {
        let viewController = RecordViewControllerFromStoryboard()
        
        prevController.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func RecordViewControllerFromStoryboard() -> RecordController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(RecordViewControllerIdentifier) as! RecordController
        
        viewController.eventHandler = recordPresenter
        recordViewController = viewController
        recordPresenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func presentEditorRoomInterface(){
        editorRoomWireframe?.presentEditingRoomInterfaceFromViewController(recordViewController!)
    }
    
    func presentGalleryInsideEditorRoomInterface(){
        editorRoomWireframe?.presentEditingRoomFromViewControllerShowGallery(recordViewController!)
    }
}