//
//  GalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 2/11/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideoGallery
import VideonaProject

class GalleryViewController: UITabBarController {
    var wireframe:GalleryWireframe?
    var interactor:SaveVideosFromGalleryInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        interactor?.setDelegate(self)
        
        self.tabBar.tintColor = mainColor
        
        for controller in self.viewControllers!{
            if let galleryController = controller.childViewControllers[0] as? VideosGalleryViewController{
                galleryController.delegate = self
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension GalleryViewController:VideoGalleryDelegate{
    func cancelPushed() {
        wireframe?.goPrevController()
    }
    
    func saveVideos(_ URLs: [URL]) {
        interactor?.saveVideos(URLs)
    }
}

extension GalleryViewController:SaveVideosFromGalleryDelegate{
    func saveVideosDone() {
        wireframe?.goPrevController()
    }
}
