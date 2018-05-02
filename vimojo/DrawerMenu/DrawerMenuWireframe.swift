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
        let mojokitURL = URL(string: "mojokit".localized(.urls))
        UIApplication.shared.open(mojokitURL!, options: [:], completionHandler: nil)
    }
    
    func presentPurchaseScreen() {
        if let controller = UIApplication.topViewController() {
            controller.show(PurchaseRouter.createModule(), sender: nil)
        }
    }
    
    func presentRecordTutorial() {
        if let controller = UIApplication.topViewController() {
            controller.show(SlideTutorial.recordingTut.viewController, sender: nil)
        }
    }
    
    func presentEditTutorial() {
        if let controller = UIApplication.topViewController() {
            controller.show(SlideTutorial.editTut.viewController, sender: nil)
        }
    }
    
    func presentUserProfile() {
        if let controller = UIApplication.topViewController() {
            controller.show(UserRouter.createModule(), sender: nil)
        }
    }
}
