//
//  UserPresenter.swift
//  LoginProject
//
//  Created Alejandro Arjonilla Garcia on 02.05.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//


import UIKit

class UserPresenter: UserPresenterProtocol {

    weak private var view: UserViewProtocol?
    var interactor: UserInteractorProtocol?
    private let router: UserWireframeProtocol

    init(interface: UserViewProtocol, interactor: UserInteractorProtocol?, router: UserWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
}
