//
//  ProjectListWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


let projectListViewControllerIdentifier = "ProjectListViewController"

class ProjectListWireframe : NSObject {
    
    var rootWireframe : RootWireframe?
    var viewController : ProjectListViewController?
    var presenter : ProjectListPresenter?
    
    var prevController:UIViewController?
    var editorRoomWireframe: EditingRoomWireframe?
    var detailProjectWireframe: DetailProjectWireframe?
    var goToRecordOrGalleryWireframe:GoToRecordOrGalleryWireframe?
    
    func presentInterfaceFromWindow(_ window: UIWindow) {
        let viewController = viewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentInterfaceFromViewController(_ prevController:UIViewController) {
        let viewController = viewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func viewControllerFromStoryboard() -> ProjectListViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: projectListViewControllerIdentifier) as! ProjectListViewController
        
        viewController.eventHandler = presenter
        self.viewController = viewController
        presenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "ProjectList", bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        viewController?.navigationController?.popViewController()
    }
    
    func presentEditorInterface(){
        if viewController != nil{
            editorRoomWireframe?.presentEditingRoomInterfaceFromViewController(viewController!)
        }
    }
    
    func presentShareInterface(){
        if viewController != nil{
            editorRoomWireframe?.presentEditingRoomFromViewControllerAndExportVideo(viewController!)
        }
    }
    
    func presentDetailProjectInterface(){
        if let viewControllerExist = viewController{
            if let uuid = presenter?.interactor?.selectedProjectUUID{
                detailProjectWireframe?.presentInterfaceFromViewController(viewControllerExist,
                                                                           videoUUID: uuid)
            }
        }
    }
    
    func navigateToRecordOrGallery(){
        if let controller = viewController{
            goToRecordOrGalleryWireframe?.presentInterfaceFromViewController(controller)
        }
    }
    
}