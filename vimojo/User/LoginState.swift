//
//  LoginState.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 09.07.18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

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
    var user: User? {
        switch self {
        case .idle: return nil
        case .loggedIn(let user): return user
        }
    }
}
var loginState: LoginState = .idle 
