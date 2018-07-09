//
//  PermissionsRouter.swift
//  vimojo
//
//  Created Jesus Huerta on 15/03/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit

class PermissionsRouter: PermissionsWireframeProtocol {

    weak var window: UIWindow?
    weak var viewController: UIViewController?
    weak var recordWireFrame: RecordWireframe?
    weak var drawerWireframe: RecordDrawerWireframe?


    static func createModule(recordWireFrame: RecordWireframe,
                             drawerWireframe: RecordDrawerWireframe,
                             window: UIWindow) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = PermissionsViewController(nibName: nil, bundle: nil)
        let router = PermissionsRouter()
        
        router.recordWireFrame = recordWireFrame
        router.drawerWireframe = drawerWireframe
        view.router = router
        router.viewController = view
        router.window = window
        
        return view
    }

    func goToRecorderScreen() {
        if  let recordController = recordWireFrame?.RecordViewControllerFromStoryboard(),
            let viewControllerToPresent = drawerWireframe?.getDrawerController(viewController: recordController)
        {
            viewControllerToPresent.forceOrientation(orientation: .lanscapeOnly)
//            viewController?.present(viewControllerToPresent, animated: true, completion: nil)
            window!.rootViewController = UINavigationController(rootViewController: viewControllerToPresent)
        }
    }
}
