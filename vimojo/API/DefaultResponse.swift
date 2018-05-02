//
//  DefaultResponse.swift
//  LoginProject
//
//  Created by Alejandro Arjonilla Garcia on 02.02.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation

enum DefaultResponse {
    case success
    case error(Error)
    
    static var responseHandler: (Int) -> DefaultResponse {
        return { code in
            let statusCode = HTTPStatusCodes(rawValue: code) ?? .badRequest
            switch statusCode {
            case .ok, .created:
                return .success
            default:
                return .error(statusCode.error)
            }
        }
    }
}
