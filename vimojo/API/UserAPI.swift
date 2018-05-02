//
//  UserAPI.swift
//  TabelRentPlatform
//
//  Created by Alejandro Arjonilla Garcia on 08.11.17.
//  Copyright © 2017 Tabel. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper

let loginProvider = MoyaProvider<UserAPI>()
var baseURLString: String {
    return "http://beta.viday.co/api/v1"
    //    return (Bundle.main.infoDictionary!["API_BASE_URL_ENDPOINT"] as? String) ?? ""
}

enum HTTPError: Error {
    case statusCode(Int)
    
    var localizedDescription: String {
        switch self {
        case .statusCode(let code): return "Http error with status code \(code)"
        }
    }
}
enum UserAPI {
    case login(user: User)
    case logout
    case register(user: User)
}
extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    var path: String {
        switch self {
            case .login: return "/login"
            case .logout: return "/user/logout"
            case .register: return "/user"
        }
    }
    var method: Moya.Method {
        switch self {
        case .logout : return .get
        case .login, .register: return .post
        }
    }
    var sampleData: Data {
        switch self {
        case .login:
            return """
            {
              email: String,
              role: String,
              token: String,
              username: String,
              verified: Bool,
              videoCount: Int,
              _id: String
            }
            """.dataUTF8!
        case .register:
            return """
            {
            "name": "Alejandro",
            "email": "mymail@mail.com",
            "_id": "5701241594183680"
            }
            """.dataUTF8!
        default:
            return "Success".dataUTF8!
        }
    }
    var task: Task {
        switch self {
        case .logout: return .requestPlain
        case .login(let user), .register(user: let user):
            print(user.toJSON())
            return .requestParameters(parameters: user.toJSON(),
                                      encoding: URLEncoding.default)
        }
    }
    var validate: Bool {
        return false
    }
    var headers: [String: String]? {
        return nil
    }
}
