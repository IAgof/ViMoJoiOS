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
    func shareVideo(indexPath:NSIndexPath, videoPath:String)
    func setShareMoviePath(moviePath:String)
    func postToYoutube(token:String)
    func getProject()->Project
}

protocol ShareInteractorDelegate{
    func setShareObjectsToView(viewObjects:[ShareViewModel])
}