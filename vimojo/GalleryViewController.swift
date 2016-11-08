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
        self.navigationController?.navigationBarHidden = false
        interactor?.setDelegate(self)
        
        self.tabBar.tintColor = VIMOJO_RED_UICOLOR
        
        for controller in self.viewControllers!{
            if let galleryController = controller.childViewControllers[0] as? VideosGalleryViewController{
                galleryController.delegate = self
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}

extension GalleryViewController:VideoGalleryDelegate{
    func cancelPushed() {
        wireframe?.goPrevController()
    }
    
    func saveVideos(URLs: [NSURL]) {
        interactor?.saveVideos(URLs)
    }
}

extension GalleryViewController:SaveVideosFromGalleryDelegate{
    func saveVideosDone() {
        wireframe?.goPrevController()
    }
}