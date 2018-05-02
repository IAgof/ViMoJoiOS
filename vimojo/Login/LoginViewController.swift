//
//  LoginViewController.swift
//
//  Created Alejandro Arjonilla Garcia on 25.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit
import RxSwift
import RxCocoa
import TransitionButton

class LoginViewController: BaseRxController, LoginViewProtocol {
    @IBOutlet weak var usernamelTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var passwordTextField: UITextField!
    var loginButton: TransitionButton = TransitionButton(frame: .zero)
    @IBOutlet weak var forgotYPButton: UIButton!
    
    var textFields: [UITextField] = []
    var presenter: LoginPresenterProtocol?
    var activeTextField: UITextField?
    
    override func configureViews() {
        loginButton.setTitle("login".localized(.settings), for: .normal)
        loginButton.setLoginAppearence()
        loginButton.spinnerColor = .white
        stackView.insertArrangedSubview(loginButton, at: stackView.subviews.count - 1)
        #if DEBUG
        usernamelTextField.text = "alex@testAlex.com"
        passwordTextField.text = "123456"
        #endif
        bindTextFields()
        bindButtons()
        textFields = [ usernamelTextField,
                       passwordTextField]
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.view.frame.origin.y = -keyboardVisibleHeight
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }).disposed(by: disposableBag)
    }
    private func bindTextFields() {
        guard let presenter = presenter else { return }
        usernamelTextField.rx.text.orEmpty.asObservable()
            .bind(to: presenter.username).disposed(by: disposableBag)
        passwordTextField.rx.text.orEmpty.asObservable()
            .bind(to: presenter.password).disposed(by: disposableBag)
    }
    private func bindButtons() {
        guard let presenter = presenter else { return }
//        presenter.isUserDataValid.asObservable().bind(to: loginButton.rx.isEnabled).disposed(by: disposableBag)
        loginButton.rx.tap.bind {
            self.loginButton.startAnimation()
            presenter.login()
            }.disposed(by: disposableBag)
    }
    func stopAnimation(with action: @escaping () -> Void, error: Bool) {
        loginButton.stopAnimation(animationStyle: error ? .shake:.expand,
                                  revertAfterDelay: 1,
                                  completion: action)
    }
}
// MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textFields.item(after: textField) {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
