//
//  RecordingCameraConfigurationRouter.swift
//  vimojo
//
//  Created Jesus Huerta on 19/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit

class RecordingCameraConfigurationRouter: RecordingCameraConfigurationWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = RecordingCameraConfigurationViewController(nibName: nil, bundle: nil)
        let interactor = RecordingCameraConfigurationInteractor()
        let router = RecordingCameraConfigurationRouter()
        let presenter = RecordingCameraConfigurationPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
}
