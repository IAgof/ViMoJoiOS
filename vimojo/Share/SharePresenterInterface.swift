//
//  SharePresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol SharePresenterInterface {
    
    func viewDidLoad()
    func viewWillDisappear()
    func pushBack()
    func setVideoExportedPath(path:String)
    func setNumberOfClipsToExport(numberOfClips:Int)
    func pushShare(indexPath:NSIndexPath)
    func expandPlayer()
    func postToYoutube(token:String)
    func updatePlayerLayer()
    func pushGenericShare()
}

protocol SharePresenterDelegate {
    func showShareGeneric(moviePath:String)
    
    func createShareInterface()
    func setShareViewObjectsList(viewObjects:[ShareViewModel])
    func bringToFrontExpandPlayerButton()
    func setNavBarTitle(title:String)
    func removeSeparatorTable()
}