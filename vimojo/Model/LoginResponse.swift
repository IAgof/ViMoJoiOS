//
//  LoginResponse.swift
//
//  Created by Alejandro Arjonilla Garcia on 27.04.18
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

public struct LoginResponse: Mappable {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let verified = "verified"
        static let id = "_id"
        static let videoCount = "videoCount"
        static let email = "email"
        static let token = "token"
        static let role = "role"
        static let username = "username"
    }
    
    // MARK: Properties
    public var verified: Bool? = false
    public var id: String?
    public var videoCount: Int?
    public var email: String?
    public var token: String?
    public var role: String?
    public var username: String?
    
    // MARK: ObjectMapper Initializers
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public init?(map: Map){
        
    }
    
    /// Map a JSON object to this class using ObjectMapper.
    ///
    /// - parameter map: A mapping from ObjectMapper.
    public mutating func mapping(map: Map) {
        verified <- map[SerializationKeys.verified]
        id <- map[SerializationKeys.id]
        videoCount <- map[SerializationKeys.videoCount]
        email <- map[SerializationKeys.email]
        token <- map[SerializationKeys.token]
        role <- map[SerializationKeys.role]
        username <- map[SerializationKeys.username]
    }
    
    /// Generates description of the object in the form of a NSDictionary.
    ///
    /// - returns: A Key value pair containing all valid values in the object.
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary[SerializationKeys.verified] = verified
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = videoCount { dictionary[SerializationKeys.videoCount] = value }
        if let value = email { dictionary[SerializationKeys.email] = value }
        if let value = token { dictionary[SerializationKeys.token] = value }
        if let value = role { dictionary[SerializationKeys.role] = value }
        if let value = username { dictionary[SerializationKeys.username] = value }
        return dictionary
    }
    
}
