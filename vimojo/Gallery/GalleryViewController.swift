//
//  GalleryViewController.swift
//  VideosGallery
//
//  Created by Alejandro Arjonilla Garcia on 2/11/16.
// Copyright (c) 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

class GalleryViewController: UITabBarController {
    var wireframe: GalleryWireframe?
    var interactor: SaveVideosFromGalleryInterface?
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        interactor?.setDelegate(self)

        self.tabBar.tintColor = configuration.mainColor

        for controller in self.viewControllers! {
            if let galleryController = controller as? VideosGalleryViewController {
                galleryController.delegate = self
            }
        }
    }
	
	func configureNavigationBarWithBackButton() {
		UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_back"), selector: #selector(cancelPushed))
		UIApplication.topViewController()?.navigationItem.rightBarButtonItem = UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_accept_normal"), selector: #selector(getVideosFromGalleryAndSave))
	}
	
	override func viewWillAppear(_ animated: Bool) {
		configureNavigationBarWithBackButton()
	}
}

extension GalleryViewController:VideoGalleryDelegate {
    func cancelPushed() {
        wireframe?.goPrevController()
    }
	
	func getVideosFromGalleryAndSave() {
		for controller in self.viewControllers! {
			if let galleryController = controller as? VideosGalleryViewController {
				galleryController.getVideosSelectedURL({
					arrayURL in
					print("Selected arrayURL")
					print(arrayURL)
					self.interactor?.saveVideos(arrayURL)
				})
				
			}
		}
	}

    func saveVideos(_ URLs: [URL]) {
        interactor?.saveVideos(URLs)
    }
}

extension GalleryViewController:SaveVideosFromGalleryDelegate {
    func saveVideosDone() {
        wireframe?.presentEditingRoomInterface()
    }
}
