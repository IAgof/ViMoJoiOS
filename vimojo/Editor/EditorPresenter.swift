//
//  EditorPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import VideonaPlayer
import VideonaProject
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class EditorPresenter: NSObject {
    //MARK: - Variables VIPER
    var delegate: EditorPresenterDelegate?
    var interactor: EditorInteractorInterface?
    
    var wireframe: EditorWireframe?
    var playerPresenter: PlayerPresenterInterface?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    //MARK: - Variables
    var selectedCellIndexPath = IndexPath(row: 0, section: 0)
    var videoToRemove = -1
    let NO_SELECTED_CELL = -1
    var stopList:[Double] = []
    var isGoingToExpandPlayer = false
    
    //MARK: - Inner functions
    func moveClipToPosition(_ sourcePosition:Int,
                            destionationPosition:Int){
        interactor?.moveClipToPosition(sourcePosition,
                                       destionationPosition: destionationPosition)
    }
    
    func reloadPositionNumberAfterMovement() {
        interactor?.reloadPositionNumberAfterMovement()

        loadVideoListFromProject()
        
        self.setVideoDataToView()
        
        selectedCellIndexPath = IndexPath(row: 0, section: 0)
    }
    
    func loadVideoListFromProject() {
        interactor?.getListData()
        
        interactor?.getComposition()
    }
    
    func getCompositionDuration()->Double{
        guard let duration = stopList.last else{
            return 0
        }
        return duration
    }
    
    func updateSelectedCellUI(_ indexPath:IndexPath){
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.deselectCell(self.selectedCellIndexPath)
            self.delegate?.selectCell(indexPath)
            self.selectedCellIndexPath = indexPath
        })
    }
    

}
extension EditorPresenter:EditorPresenterInterface{
    //MARK: - Interface
    func viewDidLoad() {
        self.reloadPositionNumberAfterMovement()
        
        //Auto select first item on first load
        self.didSelectItemAtIndexPath(selectedCellIndexPath)
        
        delegate?.setUpGestureRecognizer()
        
        wireframe?.presentPlayerInterface()
        delegate?.bringToFrontExpandPlayerButton()
        
        self.setVideoDataToView()
    }
    
    func setVideoDataToView(){
        DispatchQueue.main.async(execute: { () -> Void in
            self.delegate?.reloadCollectionViewData()
        })
    }
    
    func viewWillAppear() {
        if !isGoingToExpandPlayer{
            self.viewDidLoad()
            
            playerPresenter?.onVideoStops()
        }else{
            isGoingToExpandPlayer = false
        }
    }
    
    func viewWillDisappear() {
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
    }
    
    func didSelectItemAtIndexPath(_ indexPath: IndexPath) {
        updateSelectedCellUI(indexPath)
        
        self.seekToSelectedItem(indexPath.item)
        
        interactor?.setRangeSliderViewValues(actualVideoNumber: indexPath.item)
    }
    
    func seekToSelectedItem(_ videoPosition:Int){
        interactor?.seekToSelectedItemHandler(videoPosition)
    }
    
    func cellForItemAtIndexPath(_ indexPath: IndexPath) {
        DispatchQueue.main.async(execute: { () -> Void in
            if indexPath == self.selectedCellIndexPath {
                self.delegate?.selectCell(indexPath)
            }else{
                self.delegate?.deselectCell(indexPath)
            }
        })
        
    }
    
    func moveItemAtIndexPath(_ sourceIndexPath: IndexPath,
                             toIndexPath destinationIndexPath: IndexPath) {
        self.moveClipToPosition(sourceIndexPath.item,
                                destionationPosition: destinationIndexPath.item)
        
        if selectedCellIndexPath == sourceIndexPath {
            selectedCellIndexPath = destinationIndexPath
        }
        
        reloadPositionNumberAfterMovement()
        
        ViMoJoTracker.sharedInstance.trackClipsReordered()
    }
    
    func pushDuplicateHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentDuplicateController(selectedCellIndexPath.item)
        }
    }
    
    func pushTrimHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentTrimController(selectedCellIndexPath.item)
        }
    }
    
    func pushSplitHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentSplitController(selectedCellIndexPath.item)
        }
    }
    
    func pushAddTextHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentAddTextController(selectedCellIndexPath.item)
        }
    }
    
    func canGoToAnyEditorAction() -> Bool {
        let nClips = interactor?.getNumberOfClips()
        
        if nClips != 0 {
            return true
        }else{
            return false
        }
    }
    
    func pushAddVideoHandler() {
        wireframe?.presentGallery()
    }
    
    func expandPlayer() {
        isGoingToExpandPlayer = true
        
        wireframe?.presentExpandPlayer()
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func checkIfSelectedCellExits()->Bool{
        let numberOfCells = delegate?.numberOfCellsInCollectionView()
        
        if numberOfCells >= selectedCellIndexPath.item {
            return true
        }else{
            return false
        }
    }
    
    func seekBarUpdateHandler(_ value: Float) {
        let seekBarValue = Double(value)
        var cellPosition = 0
        
        interactor?.setRangeSliderMiddleValueUpdateWith(actualVideoNumber: selectedCellIndexPath.item,
                                                        seekBarValue: value)
        
        for time in stopList{
            if (seekBarValue < (time)){
                if cellPosition == selectedCellIndexPath.item {
                    return
                }else{
                    updateSelectedCellUI(IndexPath(item: cellPosition, section: 0))
                    interactor?.setRangeSliderViewValues(actualVideoNumber: cellPosition)
                    return
                }
            }
            cellPosition += 1
        }
    }
    
    func removeVideoClip(_ position: Int) {
        videoToRemove = position
        
        delegate?.showAlertRemove(Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_TITLE),
                                    message: Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_MESSAGE),
                                    yesString: Utils().getStringByKeyFromEditor(EditorTextConstants.YES_ACTION))
    }
    
    func removeVideoClipAfterConfirmation() {
        interactor?.removeVideo(videoToRemove)
        
        self.reloadPositionNumberAfterMovement()
    }
    
    func rangeMiddleValueChanged(_ value: Double) {
        interactor?.updateSeekOnVideoTo(value,
                                        videoNumber: selectedCellIndexPath.item)
    }
    
    func rangeSliderUpperOrLowerValueChanged(_ value: Double) {
        playerPresenter?.seekToTime(Float(value))
    }
    
    func rangeSliderUpperOrLowerValueStartToChange() {
        interactor?.getCompositionForVideo(selectedCellIndexPath.item)
        
        playerPresenter?.pauseVideo()
    }
    
    func rangeSliderLowerValueStopToChange(_ startTime: Double, stopTime: Double) {
        rangeSliderStopToChange(startTime, stopTime: stopTime)
        
        interactor?.updateSeekOnVideoTo(startTime,
                                        videoNumber: selectedCellIndexPath.item)
    }
    
    func rangeSliderUpperValueStopToChange(_ startTime: Double, stopTime: Double) {
        rangeSliderStopToChange(startTime, stopTime: stopTime)

        interactor?.updateSeekOnVideoTo(stopTime,
                                        videoNumber: selectedCellIndexPath.item)

    }
    
    func rangeSliderStopToChange(_ startTime:Double,
                                                  stopTime:Double) {
        interactor?.setTrimParametersToProject(startTime,
                                               stopTime: stopTime,
                                               videoPosition: selectedCellIndexPath.item)
        interactor?.getComposition()
        
        interactor?.getListData()
    }
    
    func playerHasLoaded() {
        seekToSelectedItem(selectedCellIndexPath.item)
    }
}

extension EditorPresenter:EditorInteractorDelegate{
    //MARK: - Interactor delegate
    func setVideoList(_ list: [EditorViewModel]) {
        delegate?.setVideoList(list)
        self.setVideoDataToView()
        
        updateSelectedCellUI(selectedCellIndexPath)
    }
    
    func setStopTimeList(_ list: [Double]) {
        self.stopList = list
    }
    
    func updateViewList() {
        delegate?.dissmissAlertController()
        
        self.loadVideoListFromProject()
    }
    
    func seekToTimeOfVideoSelectedReceiver(_ time:Float){
        playerPresenter?.seekToTime(time)
    }
    
    func setComposition(_ composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
    
    func setTrimRangeSliderViewModel(_ viewModel: TrimRangeBarViewModel) {
        delegate?.setTrimViewModel(viewModel)
    }
    
    func setTrimMiddleValue(_ value: Double) {
        delegate?.setTrimMiddleValueToView(value)
    }
}
