//
//  RecordDrawerWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class RecordDrawerWireframe {
    var projectSelectorWireframe: ProjectListWireframe?
    var goToRecordOrGalleryWireframe: GoToRecordOrGalleryWireframe?
    var project: Project?

    func getDrawerController(viewController: UIViewController) -> KYDrawerController {

        let drawerController = KYDrawerController(drawerDirection: .left, drawerWidth: 300)
        drawerController.mainViewController = viewController

        let drawerMenuController = drawerViewControllerFromStoryboard()
        drawerController.drawerViewController = drawerMenuController
        drawerController.delegate = drawerMenuController

        return drawerController
    }

    func drawerViewControllerFromStoryboard() -> RecordDrawerController {
        let storyboard = mainStoryboard()

        let viewController = storyboard.instantiateViewController(withIdentifier: "RecordDrawerController") as! RecordDrawerController
        viewController.wireframe = self

        return viewController
    }

    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Record", bundle: Bundle.main)
        return storyboard
    }

    func presentProjectsSelector() {
        if let controller = UIApplication.topViewController() {
            projectSelectorWireframe?.presentInterfaceFromViewController(controller)
        }
    }

    func presentGoToRecordOrGalleryWireframe() {
        createNewProject()
        if let controller = UIApplication.topViewController() {
            goToRecordOrGalleryWireframe?.presentInterfaceFromViewController(controller)
        }
    }

   private func createNewProject() {
        if project != nil {
            CreateNewProjectUseCase().create(project: project!)
        }
    }

}
