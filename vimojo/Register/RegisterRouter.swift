//
//  RegisterRouter.swift
//
//  Created Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit

class RegisterRouter: RegisterWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> RegisterViewController {
        let view = RegisterViewController(nibName: nil, bundle: nil)
        let interactor = RegisterInteractor()
        let router = RegisterRouter()
        let presenter = RegisterPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
    func removeView() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
