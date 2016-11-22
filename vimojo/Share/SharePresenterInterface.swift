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
    func setVideoExportedPath(_ path:String)
    func setNumberOfClipsToExport(_ numberOfClips:Int)
    func pushShare(_ indexPath:IndexPath)
    func expandPlayer()
    func postToYoutube(_ token:String)
    func updatePlayerLayer()
    func pushGenericShare()
}

protocol SharePresenterDelegate {
    func showShareGeneric(_ moviePath:String)
    
    func createShareInterface()
    func setShareViewObjectsList(_ viewObjects:[ShareViewModel])
    func bringToFrontExpandPlayerButton()
    func setNavBarTitle(_ title:String)
    func removeSeparatorTable()
}
