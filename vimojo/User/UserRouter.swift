//
//  UserRouter.swift
//  LoginProject
//
//  Created Alejandro Arjonilla Garcia on 02.05.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//


import UIKit

class UserRouter: UserWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = UserViewController(nibName: nil, bundle: nil)
        let interactor = UserInteractor()
        let router = UserRouter()
        let presenter = UserPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
