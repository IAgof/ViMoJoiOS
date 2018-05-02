//
//  RegisterPresenter.swift
//
//  Created Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit
import RxSwift

class RegisterPresenter: RegisterPresenterProtocol, RegisterInteractorOutputProtocol {
    // MARK: Input data
    var name: Variable<String> = Variable<String>("")
    var mail: Variable<String> = Variable<String>("")
    var password: Variable<String> = Variable<String>("")
    var repeatPassword: Variable<String> = Variable<String>("")
    // MARK: Validations
    var isValidName: Variable<ValidateState> = Variable<ValidateState>(.none)
    var isValidMail: Variable<ValidateState> = Variable<ValidateState>(.none)
    var isValidPassword: Variable<ValidateState> = Variable<ValidateState>(.none)
    var isButtonEnabled: Observable<Bool>
    var disposableBag: DisposeBag = DisposeBag()
    // MARK: VIPER
    weak private var view: RegisterViewProtocol?
    var interactor: RegisterInteractorInputProtocol?
    private let router: RegisterWireframeProtocol

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
    
    init(interface: RegisterViewProtocol,
         interactor: RegisterInteractorInputProtocol?,
         router: RegisterWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
        isButtonEnabled = Observable.combineLatest(isValidName.asObservable(),
                                                   isValidMail.asObservable(),
                                                   isValidPassword.asObservable()) {
                                                    return ($0.isValid && $1.isValid &&
                                                        $2.isValid)
            }.startWith(false)
        bind()
    }
    private func bind() {
        name.asObservable().map({ $0.count > 4 ? .valid:.invalid }).bind(to: isValidName).disposed(by: disposableBag)
        mail.asObservable().map({ $0.isEmail ? .valid:.invalid }).bind(to: isValidMail).disposed(by: disposableBag)
        password.asObservable().map({ $0.isValidPassword ? .valid:.invalid })
            .bind(to: isValidPassword).disposed(by: disposableBag)
    }
    func register() {
        interactor?.register(with: name.value,
                email: mail.value,
                password: password.value, response: responseCallback)
    }
}
