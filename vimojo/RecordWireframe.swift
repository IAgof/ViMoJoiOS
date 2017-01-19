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
    var settingsWireframe : SettingsWireframe?
    var drawerWireframe : DrawerMenuWireframe?
    
    func presentRecordInterfaceFromWindow(_ window: UIWindow) {
        let viewController = RecordViewControllerFromStoryboard()
        
        viewController.eventHandler = recordPresenter
        recordViewController = viewController
        recordPresenter?.delegate = viewController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .lanscapeOnly)
            rootWireframe?.showRootViewController(viewControllerToPresent, inWindow: window)
        }
    }
    
    func presentRecordInterfaceFromViewController(_ prevController:UIViewController) {
        let viewController = RecordViewControllerFromStoryboard()
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .lanscapeOnly)
            prevController.show(viewControllerToPresent, sender: nil)
        }
    }
    
    func RecordViewControllerFromStoryboard() -> RecordController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: RecordViewControllerIdentifier) as! RecordController
        
        viewController.eventHandler = recordPresenter
        recordViewController = viewController
        recordPresenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Record", bundle: Bundle.main)
        return storyboard
    }
    
    func presentEditorRoomInterface(){
        editorRoomWireframe?.presentEditingRoomInterfaceFromViewController(recordViewController!)
    }
    
    func presentGalleryInsideEditorRoomInterface(){
        editorRoomWireframe?.presentEditingRoomFromViewControllerShowGallery(recordViewController!)
    }
    
    func presentShareInterfaceInsideEditorRoom(){
        editorRoomWireframe?.presentEditingRoomFromViewControllerAndExportVideo(recordViewController!)
    }
    
    func presentSettingsInterface(){
        settingsWireframe?.presentSettingsInterfaceFromViewController(recordViewController!)
    }
}
