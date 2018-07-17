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
import VideonaProject

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
struct VideoUpload {
    let data: Data
    let title: String
    let description: String
    let productTypes: [ProjectInfo.ProductTypes]
}
enum UserAPI {
    case upload(VideoUpload)
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
        case .upload(let videoUpload):
            var multipartFormData: [MultipartFormData] = []
            multipartFormData.append(MultipartFormData(provider: .data(videoUpload.data),
                                                       name: "file",
                                                       fileName: videoUpload.title.appending(".mp4"),
                                                       mimeType: "video/mp4"))
            multipartFormData.append(MultipartFormData(provider: .data(videoUpload.title.dataUTF8!), name: "title"))
            multipartFormData.append(MultipartFormData(provider: .data(videoUpload.description.dataUTF8!), name: "description"))
            videoUpload.productTypes.forEach {
                multipartFormData.append(MultipartFormData(provider: .data($0.multipartVal.dataUTF8!), name: "productType"))
            }
            return .uploadCompositeMultipart(multipartFormData, urlParameters: [:])
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
