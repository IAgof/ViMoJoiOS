//
//  ConfigureNavBarVimojoExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension ViMoJoController {
	
	func configureNavigationBarHidden() {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	func configureNavigationBarVissible() {
		self.navigationController?.isNavigationBarHidden = false
	}
	
    func configureNavigationBarWithBackButton() {
        // let backItem = UIBarButtonItem(image: #imageLiteral(resourceName: "activity_edit_back"), style: .plain, target: self, action:#selector(pushBack))
        
        // UIApplication.topViewController()?.navigationItem.leftBarButtonItem = backItem
		
		UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_back"), selector: #selector(pushBack))
    }

    func configureNavigationBarWithDrawerAndOptions() {
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_drawer"), selector: #selector(pushShowDrawer))
        UIApplication.topViewController()?.navigationItem.rightBarButtonItems = [UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_options"), selector: #selector(pushOptions))]
    }

    func pushBack() {

    }

    func pushOptions() {

    }

    func pushShowDrawer() {
        print("Show side drawer")
        var parent = self.parent
        while parent != nil {
            if let drawer = parent as? KYDrawerController {
                if drawer.drawerState == .opened {
                    drawer.setDrawerState(.closed, animated: true)
                } else {
                    rightBarButtonItems(isEnabled: false)
                    drawer.setDrawerState(.opened, animated: true)
                }
            }
            parent = parent?.parent
        }
    }

    func rightBarButtonItems(isEnabled state: Bool) {
        if let topController = UIApplication.topViewController() {
            if let items = topController.navigationItem.rightBarButtonItems {
                for item in items {
                    item.isEnabled = state
                }
            }
        }
    }
}
