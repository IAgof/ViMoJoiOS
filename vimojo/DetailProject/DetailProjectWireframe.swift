//
//  DetailProjectWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
    
class GoToRecordOrGalleryWireframe : VimojoWireframeInterface {
        typealias viewControllerType = DetailProjectViewController
    
        var rootWireframe : RootWireframe?
        var viewController : DetailProjectViewController?
        var prevController:UIViewController?
        var viewControllerIdentifier: String
        var storyboardName: String
    
        var galleryWireframe:GalleryWireframe?
        var recordWireframe:RecordWireframe?
        var drawerWireframe:DrawerMenuWireframe?
    
        init() {
                viewControllerIdentifier = "DetailProjectViewController"
                    storyboardName = "ProjectList"
            }
    
        func presentInterfaceFromWindow(_ window: UIWindow) {
                let viewController = viewControllerFromStoryboard()
        
                rootWireframe?.showRootViewController(viewController, inWindow: window)
            }
    
        func presentInterfaceFromViewController(_ prevController: UIViewController) {
                let viewController = viewControllerFromStoryboard()
        
                self.prevController = prevController
        
                prevController.show(viewController, sender: nil)
            }
    
        func viewControllerFromStoryboard() -> GoToRecordOrGalleryWireframe.viewControllerType {
                let storyboard = getStoryboard()
                let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! GoToRecordOrGalleryWireframe.viewControllerType
        
                self.viewController = viewController
        
                return viewController
            }
    
        func getStoryboard() -> UIStoryboard{
                let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
                return storyboard
            }
    
        func goPrevController(){
                self.viewController?.navigationController?.popViewController()
            }
    
        func presentGallery(){
                if let controllerExist = viewController{
                        galleryWireframe?.presentGalleryFromViewController(controllerExist)
                    }
            }
        
        func presentRecorder() {
                if let controllerExist = viewController{
                      recordWireframe?.presentRecordInterfaceFromViewController(controllerExist)
                    }
            }
    }
