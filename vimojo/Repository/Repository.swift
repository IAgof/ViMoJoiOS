//
//  Repository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 23/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public protocol Repository {
    associatedtype T

    func add(item: T)

//    void add(Iterable<T> items);
    func add(items: [T])

    func update(item: T)

    func remove(item: T)

    func remove(specification: Specification)

    func query(specification: Specification) -> [T]
}
