//
//  EditingRoomViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import VideonaProject

class EditingRoomViewController: UITabBarController {
    var eventHandler: EditingRoomPresenterInterface?
    
    override func viewDidLoad() {
        eventHandler?.loadView()
    }
        
    override public var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}

extension EditingRoomViewController:UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("item.tag")
        print(item.tag)
        eventHandler?.controllerSelectedTag(tag: item.tag)
    }
}
