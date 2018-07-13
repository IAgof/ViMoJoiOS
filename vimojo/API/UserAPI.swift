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

var loginProvider = MoyaProvider<UserAPI>()
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
    case upload(data: Data)
}
extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: baseURLString)!
    }
    var path: String {
        switch self {
            case .upload: return "/video"
        }
    }
    var method: Moya.Method {
        switch self {
        case .upload: return .post
        }
    }
    var sampleData: Data {
        switch self {
        default:
            return "Success".dataUTF8!
        }
    }
    var task: Task {
        switch self {
        case .upload(let data):
            return .uploadCompositeMultipart([
                MultipartFormData(provider: .data(data),
                                  name: "file",
                                  fileName: "video.mp4",
                                  mimeType: "application/octet-stream")
                ], urlParameters: [
                    "title" : "Alejandro's video",
                    "description" : "Alejandro's video description",
                    "owner" : loginState.user?.id ?? "noId"
                ])
        }
    }
    var validate: Bool {
        return false
    }
    var headers: [String: String]? {
        switch self {
        case .upload:
            guard let user = loginState.user else {
                return nil
            }
            return ["Autorization" : "Bearer \(user.token ?? "")"]
        }
    }
}
