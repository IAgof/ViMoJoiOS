//
//  LoginPresenter.swift
//
//  Created Alejandro Arjonilla Garcia on 25.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit
import RxSwift

class LoginPresenter: LoginPresenterProtocol, LoginInteractorOutputProtocol {
    weak private var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    private let router: LoginWireframeProtocol
    var username: Variable<String>
    var password: Variable<String>
    var isUserDataValid: Observable<Bool>
    var responseCallback: LoginResponseCallBack {
        return { (response) in
            switch response {
            case .success:
                self.view?.stopAnimation(with: {
                    self.router.removeView()
                }, error: false)
                break
            case .error(let error):
                self.view?.stopAnimation(with: {
                    self.view?.showWhisper(with: error.localizedDescription,
                                           color: .red)
                }, error: true)
                break
            }
        }
    }
    init(interface: LoginViewProtocol, interactor: LoginInteractorInputProtocol?, router: LoginWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        username = Variable<String>("")
        password = Variable<String>("")
        isUserDataValid = Observable.combineLatest(username.asObservable().map({ $0.count >= 4 }),
                                                   password.asObservable().map({ $0.count >= 4 })) {
                                                    return ($0 && $1)
            }.startWith(false)
    }
    func login() {
        interactor?.login(with: username.value,
                password: password.value, completion: responseCallback)
    }
    func registerNow() { router.goToRegister() }
}
