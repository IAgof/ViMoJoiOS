//
//  ShareInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

protocol ShareInteractorInterface {
    func findSocialNetworks()
    func shareVideo(_ indexPath:IndexPath, videoPath:String)
    func setShareMoviePath(_ moviePath:String)
    func postToYoutube(_ token:String)
    func getProject()->Project
}

protocol ShareInteractorDelegate{
    func setShareObjectsToView(_ viewObjects:[ShareViewModel])
}
