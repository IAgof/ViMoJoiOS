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
            prevController.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func presentEditingRoomFromViewControllerAndExportVideo(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewController.selectedIndex = 2
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)

            prevController.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func presentEditingRoomFromViewControllerShowGallery(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
            viewControllerToPresent.forceOrientation(orientation: .verticalOnly)
            prevController.present(viewControllerToPresent, animated: true, completion: {
                self.galleryWireframe?.presentGalleryFromViewController(viewControllerToPresent)
            })
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
            if controller.isBeingPresented{
                self.editingRoomViewController?.present(controller, animated: true, completion: nil)
            }else{
                self.editingRoomViewController?.dismiss(animated: true, completion: nil)
            }
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
    
    func initTabBarControllers(){
        var controllers:[UIViewController]  = []
       
        if let newController = editorWireframe?.editorViewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        if let newController = musicWireframe?.musicViewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        if let newController = shareWireframe?.shareViewControllerFromStoryboard(){
            controllers.append(newController)
        }
        
        editingRoomViewController?.viewControllers = controllers
    }
    
    func presentChildController(_ controller:UIViewController){
        

    }
    
    func cycleFromViewController(_ oldViewController: UIViewController,
                                 toViewController newViewController: UIViewController) {

    }
    
    func presentSettingsInterface(){
        settingsWireframe?.presentSettingsInterfaceFromViewController(editingRoomViewController!)
    }
}
