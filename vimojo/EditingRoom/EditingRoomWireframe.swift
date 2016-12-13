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

    //MARK: - Variables
    weak var currentViewController: UIViewController?
    var prevController:UIViewController?

    func presentEditingRoomInterfaceFromWindow(_ window: UIWindow) {
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        editingRoomPresenter?.controller = viewController
        
        if let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: viewController){
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
            prevController.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    func presentEditingRoomFromViewControllerAndExportVideo(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.present(viewController, animated: true, completion: {
            DispatchQueue.main.async(execute: { () -> Void in
                self.editingRoomViewController?.eventHandler?.pushShare()
            })
        })
    }
    
    func presentEditingRoomFromViewControllerShowGallery(_ prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.present(viewController, animated: true, completion: {
            DispatchQueue.main.async(execute: { () -> Void in
                self.editorWireframe?.editorPresenter?.pushAddVideoHandler()
            })
        })
    }
    
    func EditingRoomViewControllerFromStoryboard() -> EditingRoomViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: EditingRoomViewControllerIdentifier) as! EditingRoomViewController
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        editingRoomPresenter?.controller = viewController
        
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
    
    func showEditorInContainer(){
        let controller = editorWireframe?.editorViewControllerFromStoryboard()
        self.presentChildController(controller!)
    }
    
    func showMusicInContainer(){
        let controller = musicWireframe?.musicViewControllerFromStoryboard()
   
        self.presentChildController(controller!)
    }
    
    func showShareInContainer(_ exportPath:String,
                              numberOfClips:Int){
        let controller = shareWireframe?.shareViewControllerFromStoryboard()
            controller?.exportPath = exportPath
            controller?.numberOfClips = numberOfClips
        
        self.presentChildController(controller!)
    }
    
    func presentChildController(_ controller:UIViewController){
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
       
        if currentViewController == nil {
            self.currentViewController = controller
            self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
            editingRoomViewController!.addChildViewController(self.currentViewController!)
            self.addSubview(self.currentViewController!.view,
                            toView: editingRoomViewController!.containerView)
        }else{
            self.cycleFromViewController(self.currentViewController!,
                                         toViewController: controller)
            self.currentViewController = controller
        }
    }
    
    func cycleFromViewController(_ oldViewController: UIViewController,
                                 toViewController newViewController: UIViewController) {
        oldViewController.willMove(toParentViewController: nil)
        editingRoomViewController!.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:editingRoomViewController!.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMove(toParentViewController: self.editingRoomViewController!)
        })
    }
    
    func addSubview(_ subView:UIView,
                    toView parentView:UIView) {
        
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func presentSettingsInterface(){
        settingsWireframe?.presentSettingsInterfaceFromViewController(editingRoomViewController!)
    }
}
