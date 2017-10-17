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
        
        let backItem = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 16))
        backItem.setBackgroundImage(UIImage(named: "activity_edit_drawer"), for: .normal)
        backItem.addTarget(self, action: #selector(pushBack), for: .touchUpInside)
        
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView:backItem)
    }

    func configureNavigationBarWithDrawerAndOptions() {

        let sideSliderIcon = #imageLiteral(resourceName: "activity_edit_drawer")
        let optionsIcon = #imageLiteral(resourceName: "activity_edit_options")

        let showSideSliderItem = UIBarButtonItem(image: sideSliderIcon, style: .plain, target: self, action: #selector(pushShowDrawer))
        let optionsItem = UIBarButtonItem(image: optionsIcon, style: .plain, target: self, action: #selector(pushOptions))

        if let topController = UIApplication.topViewController() {
            topController.navigationItem.leftBarButtonItems = [showSideSliderItem]
            topController.navigationItem.rightBarButtonItems = [optionsItem]

        }
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
