//
//  PurchaseRouter.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//


import UIKit

class PurchaseRouter: PurchaseWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = PurchaseViewController(nibName: nil, bundle: nil)
        let interactor = PurchaseInteractor()
        let router = PurchaseRouter()
        let presenter = PurchasePresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
