//
//  ShareActionInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

protocol ShareActionInterface {
    var delegate: ShareActionDelegate {get set}
    var shareProject: Project {get set}
    func share(_ sharePath: ShareVideoPath)
    func trackShare()
}

protocol ShareActionDelegate {
    func executeFinished()
}

protocol ShareActionResponse {

}
