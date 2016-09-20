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
    func setPositionList(list:[Int])
    func setVideoImagesList(list: [UIImage])
    func numberOfCellsInCollectionView()->Int
    func configurePickerController()
    func presentPickerController()
    func showAlertRemove(title:String,
                         message:String,
                         yesString:String)
    
    func createAlertWaitToImport()
    func dissmissAlertController()
    func bringToFrontExpandPlayerButton()
    func cameFromFullScreenPlayer(playerView:PlayerView)

}