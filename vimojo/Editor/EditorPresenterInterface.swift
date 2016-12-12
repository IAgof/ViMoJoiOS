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
    func didSelectItemAtIndexPath(_ indexPath:IndexPath)
    func cellForItemAtIndexPath(_ indexPath:IndexPath)
    func moveItemAtIndexPath(_ sourceIndexPath: IndexPath,
                             toIndexPath destinationIndexPath: IndexPath)
    func removeVideoClip(_ position:Int)
    func removeVideoClipAfterConfirmation()
    
    func pushTrimHandler()
    func pushDuplicateHandler()
    func pushSplitHandler()
    func pushAddTextHandler()
    
    func seekBarUpdateHandler(_ value: Float)
    func pushAddVideoHandler()
    
    func expandPlayer()
    func updatePlayerLayer()
    func playerHasLoaded()
    
    func rangeMiddleValueChanged(_ value:Double)
    func rangeSliderUpperOrLowerValueChanged(_ value:Double)

    func rangeSliderUpperOrLowerValueStartToChange()
    func rangeSliderLowerValueStopToChange(_ startTime:Double,
                                                  stopTime:Double)
    func rangeSliderUpperValueStopToChange(_ startTime:Double,
                                           stopTime:Double)
}

protocol EditorPresenterDelegate:ViMoJoInterface {
    func setUpGestureRecognizer()
    func selectCell(_ indexPath:IndexPath)
    func deselectCell(_ indexPath:IndexPath)
    func reloadCollectionViewData()
    func setVideoList(_ list:[EditorViewModel])
    func numberOfCellsInCollectionView()->Int
    func showAlertRemove(_ title:String,
                         message:String,
                         yesString:String)
    
    func createAlertWaitToImport(_ completion: @escaping (() -> Void))
    func dissmissAlertController()
    func bringToFrontExpandPlayerButton()
    func cameFromFullScreenPlayer(_ playerView:PlayerView)
    
    func setTrimViewModel(_ viewModel:TrimRangeBarViewModel)
    func setTrimMiddleValueToView(_ value:Double)
}
