//
//  GalleryWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 3/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


let galleryViewControllerIdentifier = "GalleryViewController"

class GalleryWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var galleryViewController: GalleryViewController?
    var prevController:UIViewController?
    var interactor:SaveVideosFromGalleryInterface?
    
    func presentGalleryFromViewController(prevController:UIViewController) {
        let viewController = galleryViewControllerFromStoryboard()
        viewController.wireframe = self
        viewController.interactor = interactor
        
        self.prevController = prevController
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func galleryViewControllerFromStoryboard() -> GalleryViewController {
        let storyboard = galleryStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(galleryViewControllerIdentifier) as! GalleryViewController
        
        galleryViewController = viewController
        
        return viewController
    }
    
    func galleryStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Gallery", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func goPrevController(){
        galleryViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}