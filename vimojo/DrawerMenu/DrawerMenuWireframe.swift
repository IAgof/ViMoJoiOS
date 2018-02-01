//
//  DrawerMenuWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class DrawerMenuWireframe {
    var presenter: DrawerMenuPresenter?

    var projectSelectorWireframe: ProjectListWireframe?
    var settingsWireframe: SettingsWireframe?
    var goToRecordOrGalleryWireframe: GoToRecordOrGalleryWireframe?

    func getDrawerController(viewController: UIViewController) -> KYDrawerController {

        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = viewController

        let drawerMenuController = drawerViewControllerFromStoryboard()
        drawerController.drawerViewController = drawerMenuController
        drawerController.delegate = drawerMenuController

        return drawerController
    }

    func drawerViewControllerFromStoryboard() -> DrawerMenuTableViewController {
        let storyboard = mainStoryboard()

        let viewController = storyboard.instantiateViewController(withIdentifier: "DrawerMenuTableViewController") as! DrawerMenuTableViewController
        viewController.eventHandler = presenter
        presenter?.delegate = viewController

        return viewController
    }

    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Drawer", bundle: Bundle.main)
        return storyboard
    }

    func presentProjectsSelector() {
        if let controller = UIApplication.topViewController() {
            projectSelectorWireframe?.presentInterfaceFromViewController(controller)
        }
    }

    func presentSettings() {
        if let controller = UIApplication.topViewController() {
            settingsWireframe?.presentSettingsInterfaceFromViewController(controller)
        }
    }

    func presentGoToRecordOrGalleryWireframe() {
        if let controller = UIApplication.topViewController() {
            goToRecordOrGalleryWireframe?.presentInterfaceFromViewController(controller)
        }
    }
    
    func goToMojoKit() {
        let twitterBrowserURL = URL(string: "http://vimojo.co/mojokit/?utm_source=vimojo_ios&utm_medium=app_link")
        UIApplication.shared.open(twitterBrowserURL!, options: [:], completionHandler: nil)
    }
    
    func goToShop() {
        // Open cart
    }
}
