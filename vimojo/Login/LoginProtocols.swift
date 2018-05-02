//
//  LoginProtocols.swift
//
//  Created Alejandro Arjonilla Garcia on 25.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import Foundation
import RxSwift

// MARK: Wireframe -
protocol LoginWireframeProtocol: class {
    func goToRegister()
    func removeView()
}
// MARK: Presenter -
protocol LoginPresenterProtocol: class {
    var username: Variable<String> { get }
    var password: Variable<String> { get }
    var isUserDataValid: Observable<Bool> { get }
    var interactor: LoginInteractorInputProtocol? { get set }

    func login()
    func registerNow()
}

// MARK: Interactor -
protocol LoginInteractorOutputProtocol: class {

    /* Interactor -> Presenter */
}

protocol LoginInteractorInputProtocol: class {

    var presenter: LoginInteractorOutputProtocol? { get set }
    func login(with email: String, password: String, completion: @escaping LoginResponseCallBack)
    /* Presenter -> Interactor */
}

// MARK: View -
protocol LoginViewProtocol: class, BaseViewProtocol {

    var presenter: LoginPresenterProtocol? { get set }
    /* Presenter -> ViewController */
    func stopAnimation(with action: @escaping () -> Void, error: Bool)
}
