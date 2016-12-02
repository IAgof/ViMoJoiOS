//
//  RootWireframe.swift
//  ViMoJo
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import KYDrawerController

class RootWireframe : NSObject {
    
    func showRootViewController(_ viewController: UIViewController, inWindow: UIWindow) {

        let drawerController     = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = viewController
        drawerController.drawerViewController = DrawerViewControllerFromStoryboard()
        
        inWindow.rootViewController = drawerController
        inWindow.makeKeyAndVisible()
    }
    
    func navigationControllerFromWindow(_ window: UIWindow) -> UINavigationController {
        let navigationController = window.rootViewController as! UINavigationController
        return navigationController
    }
    
    func DrawerViewControllerFromStoryboard() -> DrawerMenuTableViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: "DrawerMenuTableViewController") as! DrawerMenuTableViewController

        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
}
