//
//  RegisterProtocols.swift
//
//  Created Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import Foundation
import RxSwift

// MARK: Wireframe -
protocol RegisterWireframeProtocol: class {
    func removeView()
}
// MARK: Presenter -
protocol RegisterPresenterProtocol: class {

    var interactor: RegisterInteractorInputProtocol? { get set }
    var name: Variable<String> { get }
    var mail: Variable<String> { get }
    var password: Variable<String> { get }
    var isValidName: Variable<ValidateState> { get }
    var isValidMail: Variable<ValidateState> { get }
    var isValidPassword: Variable<ValidateState> { get }
    var isButtonEnabled: Observable<Bool> { get }

    func register()
}

// MARK: Interactor -
protocol RegisterInteractorOutputProtocol: class {

    /* Interactor -> Presenter */
}

protocol RegisterInteractorInputProtocol: class {

    var presenter: RegisterInteractorOutputProtocol? { get set }

    /* Presenter -> Interactor */
    func register(with name: String,
                  email: String,
                  password: String,
                  response: @escaping (DefaultResponse) -> Void)
}

// MARK: View -
protocol RegisterViewProtocol: class, BaseViewProtocol {

    var presenter: RegisterPresenterProtocol? { get set }

    /* Presenter -> ViewController */
    func stopAnimation(with action: @escaping () -> Void, error: Bool)

}
