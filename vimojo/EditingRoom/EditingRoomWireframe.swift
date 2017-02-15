//
//  EditingRoomWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

let EditingRoomViewControllerIdentifier = "EditingRoomViewController"

class EditingRoomWireframe : NSObject {
    //MARK: - Variables VIPER
    var rootWireframe : RootWireframe?
    var editingRoomViewController : EditingRoomViewController?
    var editingRoomPresenter : EditingRoomPresenter?
    
    var editorWireframe: EditorWireframe?
    var musicWireframe: MusicWireframe?
    var shareWireframe: ShareWireframe?
    var settingsWireframe:SettingsWireframe?
    var drawerWireframe : DrawerMenuWireframe?
    var recordWireframe : RecordWireframe?
    var galleryWireframe:GalleryWireframe?
    var musicListWireframe:MusicListWireframe?
    var goToRecordOrGalleryWireframe:GoToRecordOrGalleryWireframe?
    var addFilterToVideoWireframe:AddFilterToVideoWireframe?
    
    //MARK: - Variables
    weak var currentViewController: UIViewController?
    var prevController:UIViewController?

    func presentEditingRoomInterfaceFromWindow(_ window: UIWindow) {
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)
            rootWireframe?.showRootViewController(viewControllerToPresent, inWindow: window)
        }
    }
    
    
    func setEditingRoomViewControllerAsRootController() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let homeViewController =  EditingRoomViewControllerFromStoryboard()
        let nav = UINavigationController(rootViewController: homeViewController)
        appdelegate.window!.rootViewController = nav
    }
    
    func presentEditingRoomInterfaceFromViewController(_ prevController:UIViewController) {
        let viewController = EditingRoomViewControllerFromStoryboard()

        self.prevController = prevController

        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)
            viewController.selectedIndex = 0
            prevController.show(viewControllerToPresent, sender: nil)
        }
    }
    
    func presentEditingRoomFromViewControllerAndExportVideo(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewController.selectedIndex = 2
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)

            prevController.show(viewControllerToPresent, sender: nil)
        }
    }
    
    func presentEditingRoomFromViewControllerShowGallery(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)
            prevController.show(viewControllerToPresent, sender: nil)
        }
    }
    
    func EditingRoomViewControllerFromStoryboard() -> EditingRoomViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: EditingRoomViewControllerIdentifier) as! EditingRoomViewController
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Editor", bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        if let controller = prevController{
            editingRoomViewController?.navigationController?.popToViewController(controller, animated: true)
        }
    }
    
    func navigateToRecorder(){
        if let controller = editingRoomViewController{
            recordWireframe?.presentRecordInterfaceFromViewController(controller)
        }
    }
    
    func navigateToSettings(){
        if let controller = editingRoomViewController{
            settingsWireframe?.presentSettingsInterfaceFromViewController(controller)
        }
    }
    
    func navigateToGallery(){
        if let controller = editingRoomViewController{
            galleryWireframe?.presentGalleryFromViewController(controller)
        }
    }
    
    func navigateToRecordOrGallery(){
        if let controller = editingRoomViewController{
            goToRecordOrGalleryWireframe?.presentInterfaceFromViewController(controller)
        }
    }
    
    func initTabBarControllers(){
        var controllers:[UIViewController]  = []
        
        if let newController = editorWireframe?.editorViewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        if configuration.VOICE_OVER_FEATURE{
            if let newController = musicWireframe?.musicViewControllerFromStoryboard(){
                controllers.append(newController)
            }
        }else{
            if let newController = musicListWireframe?.musicViewControllerFromStoryboard(){
                controllers.append(newController)
            }
        }
        
        if let newController = addFilterToVideoWireframe?.viewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        if let newController = shareWireframe?.shareViewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        editingRoomViewController?.viewControllers = controllers
    }

    func presentSettingsInterface(){
        settingsWireframe?.presentSettingsInterfaceFromViewController(editingRoomViewController!)
    }
}
