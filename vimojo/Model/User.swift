//
//  User.swift
//  TabelRentPlatform
//
//  Created by Alejandro Arjonilla Garcia on 30.10.17.
//  Copyright © 2017 Tabel. All rights reserved.
//

import Foundation
import ObjectMapper

protocol UserProtocol {
    var name: String? { get set }
    var password: String? { get set }
    var email: String? { get set }
    var id: String? { get set }
    var token: String? { get set }
}
struct User: UserProtocol, Mappable {
    var name: String?
    var password: String?
    var email: String?
    var id: String?
    var token: String?
    var pic: String?
    init?(map: Map) {
        mapping(map: map)
    }
    
    init (with username: String, password: String) {
        self.name = username
        self.password = password
    }
    init (with name: String?,
          email: String,
          password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
    // Mappable
    mutating func mapping(map: Map) {
        name <- map["username"]
        password <- map["password"]
        email <- map["email"]
        id <- map["_id"]
        token <- map["token"]
        pic <- map["pic"]
    }
}
