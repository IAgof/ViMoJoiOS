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
    func viewDidAppear()
    func pushBack()
    func setVideoExportedPath(_ url: URL) 
    func setNumberOfClipsToExport(_ numberOfClips:Int)
    func pushShare(_ indexPath:IndexPath)
    func expandPlayer()
    func postToYoutube(_ token:String)
    func updatePlayerLayer()
    func pushGenericShare()
    func pushOptions()
}

protocol SharePresenterDelegate {
    func createAlertWaitToExport()
    func dissmissAlertWaitToExport()

    func showShareGeneric(_ movieURL:URL)
    
    func createShareInterface()
    func setShareViewObjectsList(_ viewObjects:[ShareViewModel])
    func bringToFrontExpandPlayerButton()
    func removeSeparatorTable()
}
