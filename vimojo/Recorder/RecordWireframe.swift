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

class RecordWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var recordViewController: RecordController?
    var recordPresenter: RecordPresenter?
    
    var editorRoomWireframe: EditingRoomWireframe?
    var settingsWireframe: SettingsWireframe?
    var drawerWireframe: RecordDrawerWireframe?
    var galleryWireframe: GalleryWireframe?
    
    func presentRecordInterfaceFromWindow(_ window: UIWindow) {
        let viewController = RecordViewControllerFromStoryboard()
        
        viewController.eventHandler = recordPresenter
        recordViewController = viewController
        recordPresenter?.delegate = viewController
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
        
        //TODO: remove drawer from record controller, to prevent no exit on settings and gallery
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController) {
            viewControllerToPresent.forceOrientation(orientation: .lanscapeOnly)
            rootWireframe?.showRootViewController(viewControllerToPresent, inWindow: window)
        }
    }
    func showRecordInterfaceFromViewController(_ prevController: UIViewController) {
        let viewController = RecordViewControllerFromStoryboard()
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController) {
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
    
    func presentEditorRoomInterface() {
        recordViewController?.setNavigationBarHidden(isHidden: false)
        
        editorRoomWireframe?.presentEditingRoomInterfaceFromViewController(recordViewController!)
    }
    
    func presentGallery() {
        recordViewController?.setNavigationBarHidden(isHidden: false)
        if let controllerExist = recordViewController {
            galleryWireframe?.presentGalleryFromViewController(controllerExist)
        }
    }
    
    func presentShareInterfaceInsideEditorRoom() {
        recordViewController?.setNavigationBarHidden(isHidden: false)
        editorRoomWireframe?.presentEditingRoomFromViewControllerAndExportVideo(recordViewController!)
    }
    
    func presentSettingsInterface() {
        recordViewController?.navigationController?
            .show(RecordingCameraConfigurationRouter.createModule(),
                                                         sender: nil)
    }
    func presentRecordTutorial() {
        if let controller = UIApplication.topViewController() {
            controller.show(SlideTutorial.recordingTut.viewController, sender: nil)
            SlideTutorial.recordingTut.viewController.orientation = .portraitUpsideDown
        }
    }
}
