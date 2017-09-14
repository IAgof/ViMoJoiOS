//
//  DetailProjectWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

class DetailProjectWireframe: VimojoWireframeInterface {
    typealias viewControllerType = DetailProjectViewController
    typealias presenterType = DetailProjectPresenter

    var rootWireframe: RootWireframe?
    var viewController: viewControllerType?
    var presenter: presenterType?

    var prevController: UIViewController?
    var viewControllerIdentifier: String
    var storyboardName: String

    private var videoSelectedUUID: String?

    init() {
        viewControllerIdentifier = "DetailProjectViewController"
        storyboardName = "ProjectList"
    }

    func presentInterfaceFromWindow(_ window: UIWindow) {
        let viewController = viewControllerFromStoryboard()

        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }

    func presentInterfaceFromViewController(_ prevController: UIViewController,
                                            videoUUID: String) {
        self.videoSelectedUUID = videoUUID

        presentInterfaceFromViewController(prevController)
    }

    func presentInterfaceFromViewController(_ prevController: UIViewController) {
        let viewController = viewControllerFromStoryboard()

        self.prevController = prevController

        viewController.eventHandler = presenter

        presenter?.delegate = viewController
        if let uuid = videoSelectedUUID {
            presenter?.interactor?.videoUUID = uuid
        }

        prevController.show(viewController, sender: nil)
    }

    func viewControllerFromStoryboard() -> DetailProjectWireframe.viewControllerType {
        let storyboard = getStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! DetailProjectWireframe.viewControllerType

        self.viewController = viewController

        return viewController
    }

    func getStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard
    }

    func goPrevController() {
        self.viewController?.navigationController?.popViewController()
    }
}
