//
//  RegisterInteractor.swift
//
//  Created Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit

class RegisterInteractor: RegisterInteractorInputProtocol {

    weak var presenter: RegisterInteractorOutputProtocol?

    func register(with name: String, email: String, password: String,
                  response:  @escaping (DefaultResponse) -> Void) {
        let user = User(with: name, email: email, password: password)
        loginProvider.request(.register(user: user)) { result in
            switch result {
                case .failure(let error): response(.error(error))
                case .success(let value):
                    response(DefaultResponse.responseHandler(value.statusCode))
            }
        }
    }
}
