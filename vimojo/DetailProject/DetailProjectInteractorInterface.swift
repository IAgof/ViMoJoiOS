//
//  DetailProjectInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

protocol DetailProjectInteractorInterface {
    func searchProjectParams()
    var videoUUID:String{get set}
}

protocol DetailProjectInteractorDelegate {
    func projectFound(params:DetailProjectFound)
}
