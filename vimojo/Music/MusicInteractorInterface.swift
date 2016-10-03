//
//  MusicInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaProject

protocol MusicInteractorInterface {
    func getMusicList()
    func getTitleFromIndexPath(index:Int)->String
    func getAuthorFromIndexPath(index:Int)->String
    func getImageFromIndexPath(index:Int)->UIImage
    func setMusicToProject(index:Int)
    func hasMusicSelectedInProject()->Bool
    func getMusic()->Music
    func getProject()->Project
}

protocol MusicInteractorDelegate {
    func setMusicModelList(list:[MusicViewModel])
}