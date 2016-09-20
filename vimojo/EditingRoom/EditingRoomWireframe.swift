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
//    var musicWireframe: MusicWireframe?
//    var shareWireframe: ShareWireframe?
//    var settingsWireframe:SettingsWireframe?
    
    //MARK: - Variables
    weak var currentViewController: UIViewController?
    var prevController:UIViewController?

    func presentEditingRoomInterfaceFromWindow(window: UIWindow) {
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        editingRoomPresenter?.controller = viewController
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func setEditingRoomViewControllerAsRootController() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let homeViewController =  EditingRoomViewControllerFromStoryboard()
        let nav = UINavigationController(rootViewController: homeViewController)
        appdelegate.window!.rootViewController = nav
    }
    
    func presentEditingRoomInterfaceFromViewController(prevController:UIViewController) {
        let viewController = EditingRoomViewControllerFromStoryboard()

        self.prevController = prevController

        prevController.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func presentEditingRoomFromViewControllerAndExportVideo(prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.presentViewController(viewController, animated: true, completion: {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.editingRoomViewController?.eventHandler?.pushShare()
            })
        })
    }
    
    func presentEditingRoomFromViewControllerShowGallery(prevController:UIViewController){
        let viewController = EditingRoomViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.presentViewController(viewController, animated: true, completion: {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.editorWireframe?.editorPresenter?.pushAddVideoHandler()
            })
        })
    }
    
    func EditingRoomViewControllerFromStoryboard() -> EditingRoomViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(EditingRoomViewControllerIdentifier) as! EditingRoomViewController
        
        viewController.eventHandler = editingRoomPresenter
        editingRoomViewController = viewController
        editingRoomPresenter?.controller = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func goPrevController(){
            self.editingRoomViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func goBackToEditingRoomView(prevController:UIViewController){

        prevController.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func showEditorInContainer(){
        let controller = editorWireframe?.editorViewControllerFromStoryboard()
        self.presentChildController(controller!)
    }
    
    func showMusicInContainer(){
//        let controller = musicWireframe?.musicViewControllerFromStoryboard()
//   
//        self.presentChildController(controller!)
    }
    
    func showShareInContainer(exportPath:String,
                              numberOfClips:Int){
//        let controller = shareWireframe?.shareViewControllerFromStoryboard()
//            controller?.exportPath = exportPath
//            controller?.numberOfClips = numberOfClips
//        
//        self.presentChildController(controller!)
    }
    
    func presentChildController(controller:UIViewController){
        
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
    
    func cycleFromViewController(oldViewController: UIViewController,
                                 toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        editingRoomViewController!.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:editingRoomViewController!.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self.editingRoomViewController!)
        })
    }
    
    func addSubview(subView:UIView,
                    toView parentView:UIView) {
        
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    func presentSettingsInterface(){
//        settingsWireframe?.presentSettingsInterfaceFromViewController(editingRoomViewController!)
    }
}