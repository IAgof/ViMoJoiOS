//
//  ShareActionInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ShareActionInterface {
    func share(path:String)
    var delegate:ShareActionDelegate {get set}
}

protocol ShareActionDelegate {
    func executeFinished()
}

protocol ShareActionResponse {
    
}

