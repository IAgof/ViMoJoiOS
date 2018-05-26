//
//  LoginInteractor.swift
//
//  Created Alejandro Arjonilla Garcia on 25.10.17.
//  Copyright © 2017 Tabel. All rights reserved.

import UIKit
import RxSwift
import Moya_ObjectMapper
import Moya

struct LoginUser {
    let name: String
    let mail: String
    let password: String
    
    init(name: String = "", mail: String = "", password: String = "") {
        self.name = name
        self.mail = mail
        self.password = password
    }
}
enum LoginResonse {
    case valid
    case error(Error)
}
enum LoginState {
    case idle, loggedIn(user: User)
    
    static var defaultsKey = "LoginStateDefaultKey"
    
    static func loadState() {
        guard let user = UserDefaults.standard.value(forKey: LoginState.defaultsKey) as? [String: Any],
        let userMapped = User(JSON: user )
            else { return }
        loginState = .loggedIn(user: userMapped)
    }
}
var loginState: LoginState = .idle {
    didSet {
        switch loginState {
        case .idle:
            UserDefaults.standard.set(nil, forKey: LoginState.defaultsKey)
        case .loggedIn(let user):
            UserDefaults.standard.set(user.toJSON(), forKey: LoginState.defaultsKey)
        }
    }
}

class LoginInteractor: LoginInteractorInputProtocol {

    weak var presenter: LoginInteractorOutputProtocol?
  
    var responseHandler: (Response) -> DefaultResponse {
        return { response in
            let statusCode = HTTPStatusCodes(rawValue: response.statusCode) ?? .badRequest
            switch statusCode {
            case .ok, .created:
                if let user = try? response.mapObject(User.self) {
                    loginState = .loggedIn(user: user)
                }
                return .success
            default:
                return .error(statusCode.error)
            }
        }
    }
    func login(with email: String, password: String,
               completion: @escaping LoginResponseCallBack) {
        let user = User(with: nil, email: email, password: password)
        loginProvider.request(.login(user: user)) { response in
            switch response {
            case .failure(let error): completion(.error(error))
            case .success(let value):
                completion(self.responseHandler(value))
            }
        }
        loginProvider.request(.upload(data: Data()), progress: { (progress) in
            
        }) { (response) in
            
        }
    }
}
