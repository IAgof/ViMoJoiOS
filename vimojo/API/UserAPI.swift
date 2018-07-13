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
//    return "http://35.174.99.151/api/v1"
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
                                  mimeType: "video/mp4"),
                MultipartFormData(provider: .data("title".dataUTF8!), name: "title"),
                MultipartFormData(provider: .data("description".dataUTF8!), name: "description"),
                MultipartFormData(provider: .data("LIVE_ON_TAPE".dataUTF8!), name: "productType"),
                ], urlParameters: [:])
        }
    }
    var validate: Bool {
        return false
    }
    var headers: [String: String]? {
        switch self {
        case .upload:
            let token = SessionManager.shared.credentials?.accessToken ?? "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik9FTkVPRGc1TmtFM01qVXhNVFl4TnpRNE9VWkNPVVk1UmpWQk1qTTBSRUpETWtKRk5qVkNRUSJ9.eyJpc3MiOiJodHRwczovL3ZpbW9qby5ldS5hdXRoMC5jb20vIiwic3ViIjoiYXV0aDB8NWI0ODcwMzgwM2EyZGMxZTkxZmM2OWM1IiwiYXVkIjpbImh0dHBzOi8vdmltb2pvLmF1dGgvYXBpIiwiaHR0cHM6Ly92aW1vam8uZXUuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTUzMTQ4NDc0MiwiZXhwIjoxNTMxNTIwNzQyLCJhenAiOiI5ejJDbzBOcFR3WE5zaGZTdmgwZGh5Q3V3VzBTNXg0RSIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgZW1haWwifQ.TZOaOVR25n1nI5kRC3vvTB7KEa-wh-biyt08WibYx4fzudrYkC3jr3vWwRPRqtiPnkW6AYjcf9q-VMzxwzOSofoZUgSCvnTgyoRIByZgU42rNT5BrX56ojjv0b8TmQe0CbvJrWkdk5Y5f8eHVHGcfv1zn6Q2N5ewKAai84Hl81Qr8Tbu4u541id_mF8BmtwjuO8dsJI62sec9I2Ca5zkgWVnnzy4mGubAdgKd5L7QxspoZFzG0LmBxkIT20aAcjufo2_nxjkY2Bw9Xt2wx5hK41l2LPXkpqr9dzGx4B_Qhkv6ukeHuvlcfhB2DN6CUU26zS_1qB35AnxKsoyTV30yg"
            return ["Authorization" : "Bearer \(token)"]
        }
    }
}
