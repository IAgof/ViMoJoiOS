//
//  RegisterViewController.swift
//
//  Created Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit
import RxCocoa
import RxSwift
import TransitionButton

class RegisterViewController: BaseRxController, RegisterViewProtocol {
    // MARK: Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var privacyButton: UIButton!
    @IBOutlet weak var termsSwitch: UISwitch!

    var registerButton: TransitionButton = TransitionButton(frame: .zero)
    // MARK: Variables
    var presenter: RegisterPresenterProtocol?
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViews()
    }
    override func configureViews() {
        registerButton.setTitle("login".localized(.settings), for: .normal)
        registerButton.setLoginAppearence()
        registerButton.spinnerColor = .white
        stackView.insertArrangedSubview(registerButton, at: stackView.subviews.count - 1)
        #if DEBUG
        nameTextField.text = "Alex"
        mailTextField.text = "alex@testAlex.com"
        passwordTextField.text = "123456"
        #endif
    }
    // MARK: View binding
    private func bindViews() {
        guard let presenter = presenter else { return }
        nameTextField.rx.text.orEmpty.asObservable().bind(to: presenter.name).disposed(by: disposableBag)
        mailTextField.rx.text.orEmpty.asObservable().bind(to: presenter.mail).disposed(by: disposableBag)
        passwordTextField.rx.text.orEmpty.asObservable().bind(to: presenter.password).disposed(by: disposableBag)
        
        registerButton.rx.tap.bind {
            if self.termsSwitch.isOn {
                self.registerButton.startAnimation()
                self.presenter?.register()
            } else {
                self.showWhisper(with: "Accept terms of service".localized(.settings), color: .orange)
            }
            }.disposed(by: disposableBag)
        termsButton.rx.tap.bind {
            self.showWhisper(with: "Terms", color: .green)
            }.disposed(by: disposableBag)
        privacyButton.rx.tap.bind {
            self.showWhisper(with: "Privacy", color: .green)
            }.disposed(by: disposableBag)
    }
    func stopAnimation(with action: @escaping () -> Void, error: Bool) {
        registerButton.stopAnimation(animationStyle: error ? .shake:.expand,
                                     revertAfterDelay: 1,
                                     completion: action)
    }
}
