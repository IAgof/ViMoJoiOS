//
//  LoginRouter.swift
//
//  Created Alejandro Arjonilla Garcia on 25.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit

class LoginRouter: LoginWireframeProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> LoginViewController {
        let view = LoginViewController(nibName: nil, bundle: nil)
        let interactor = LoginInteractor()
        let router = LoginRouter()
        let presenter = LoginPresenter(interface: view, interactor: interactor, router: router)

        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view

        return view
    }
    func goToRegister() {
        viewController?.navigationController?.show(RegisterRouter.createModule(), sender: nil)
    }
    func removeView() {
        viewController?.navigationController?.dismiss(animated: true, completion: nil)
    }
}
