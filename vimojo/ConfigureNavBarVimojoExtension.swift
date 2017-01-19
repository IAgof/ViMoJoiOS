//
//  ConfigureNavBarVimojoExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import KYDrawerController

extension ViMoJoController{
    func configureNavigationBarWithBackButton(){
        let backIcon = #imageLiteral(resourceName: "activity_edit_back")
        
        let backItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action:#selector(pushBack))
        
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = backItem
    }
    
    func configureNavigationBarWithDrawerAndOptions(){
        
        
        let sideSliderIcon = #imageLiteral(resourceName: "activity_edit_drawer")
        let optionsIcon = #imageLiteral(resourceName: "activity_edit_options")
        
        let showSideSliderItem = UIBarButtonItem(image: sideSliderIcon, style: .plain, target: self, action: #selector(pushShowDrawer))
        let optionsItem = UIBarButtonItem(image: optionsIcon, style: .plain, target: self, action: #selector(pushOptions))
        
        UIApplication.topViewController()?.navigationItem.leftBarButtonItem = showSideSliderItem
        UIApplication.topViewController()?.navigationItem.rightBarButtonItems = [optionsItem]
    }
    
    func pushBack(){
        
    }
    
    func pushOptions(){
        
    }
        
    func pushShowDrawer(){
        print("Show side drawer")
        var parent = self.parent
        while parent != nil {
            if let drawer = parent as? KYDrawerController{
                drawer.setDrawerState(.opened, animated: true)
            }
            parent = parent?.parent
        }
    }
}
