//
//  EditorViewInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

protocol EditorViewInterface:ViMoJoInterface {
    func setUpGestureRecognizer()
    func selectCell(indexPath:NSIndexPath)
    func deselectCell(indexPath:NSIndexPath)
    func reloadCollectionViewData()
    func setVideoList(list:[EditorViewModel])
    func numberOfCellsInCollectionView()->Int
    func showAlertRemove(title:String,
                         message:String,
                         yesString:String)
    
    func createAlertWaitToImport(completion: (() -> Void)?)
    func dissmissAlertController()
    func bringToFrontExpandPlayerButton()
    func cameFromFullScreenPlayer(playerView:PlayerView)
}