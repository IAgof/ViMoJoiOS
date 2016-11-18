//
//  EditorPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer

protocol EditorPresenterInterface {
    func viewDidLoad()
    func viewWillDisappear()
    func viewWillAppear()
    func didSelectItemAtIndexPath(indexPath:NSIndexPath)
    func cellForItemAtIndexPath(indexPath:NSIndexPath)
    func moveItemAtIndexPath(sourceIndexPath: NSIndexPath,
                             toIndexPath destinationIndexPath: NSIndexPath)
    func removeVideoClip(position:Int)
    func removeVideoClipAfterConfirmation()
    
    func pushTrimHandler()
    func pushDuplicateHandler()
    func pushSplitHandler()
    func pushAddTextHandler()
    
    func seekBarUpdateHandler(value: Float)
    func pushAddVideoHandler()
       
    func expandPlayer()
    func updatePlayerLayer()
    
    func rangeMiddleValueChanged(value:Double)
}

protocol EditorPresenterDelegate:ViMoJoInterface {
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
    
    func setTrimViewModel(viewModel:TrimRangeBarViewModel)
    func setTrimMiddleValueToView(value:Double)
}