//
//  Mapper.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 23/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public protocol Mapper {
    associatedtype From
    associatedtype To
    
    func map(from:From)->To
}
