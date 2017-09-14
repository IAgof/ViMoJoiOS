//
//  GalleryWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 3/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

let galleryViewControllerIdentifier = "GalleryViewController"

class GalleryWireframe: NSObject {
    var rootWireframe: RootWireframe?
    var galleryViewController: GalleryViewController?
    var prevController: UIViewController?
    var interactor: SaveVideosFromGalleryInterface?

    var editingRoomWireframe: EditingRoomWireframe?

    func presentGalleryFromViewController(_ prevController: UIViewController) {
        let viewController = galleryViewControllerFromStoryboard()
        viewController.wireframe = self
        viewController.interactor = interactor

        self.prevController = prevController

        prevController.show(viewController, sender: nil)
    }

    func galleryViewControllerFromStoryboard() -> GalleryViewController {
        let storyboard = galleryStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: galleryViewControllerIdentifier) as! GalleryViewController

        galleryViewController = viewController

        return viewController
    }

    func galleryStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Gallery", bundle: Bundle.main)
        return storyboard
    }

    func goPrevController() {
        galleryViewController?.navigationController?.popViewController()
    }

    func presentEditingRoomInterface() {
        if let controllerExist = galleryViewController {
            editingRoomWireframe?.presentEditingRoomInterfaceFromViewController(controllerExist)
        }
    }
}
