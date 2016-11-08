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

class EditorPresenter: NSObject,EditorPresenterInterface,EditorInteractorDelegate {
    //MARK: - Variables VIPER
    var controller: EditorViewInterface?
    var interactor: EditorInteractorInterface?
    
    var wireframe: EditorWireframe?
    var playerPresenter: PlayerPresenterInterface?
    var playerWireframe: PlayerWireframe?
    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?

    //MARK: - Variables
    var selectedCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    var videoToRemove = -1
    let NO_SELECTED_CELL = -1
    var stopList:[Double] = []
    var isGoingToExpandPlayer = false
    
    //MARK: - Interface
    func viewDidLoad() {
        self.reloadPositionNumberAfterMovement()
        
        //Auto select first item on first load
        self.didSelectItemAtIndexPath(selectedCellIndexPath)
        
        controller?.setUpGestureRecognizer()
        
        wireframe?.presentPlayerInterface()
        controller?.bringToFrontExpandPlayerButton()

        self.setVideoDataToView()
    }
    
    func setVideoDataToView(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.controller?.reloadCollectionViewData()
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
    
    func didSelectItemAtIndexPath(indexPath: NSIndexPath) {
        updateSelectedCellUI(indexPath)
        
        self.seekToSelectedItem(indexPath.item)
    }
    
    func seekToSelectedItem(videoPosition:Int){
        interactor?.seekToSelectedItemHandler(videoPosition)
    }
    
    func cellForItemAtIndexPath(indexPath: NSIndexPath) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if indexPath == self.selectedCellIndexPath {
                self.controller?.selectCell(indexPath)
            }else{
                self.controller?.deselectCell(indexPath)
            }
        })

    }
    
    func moveItemAtIndexPath(sourceIndexPath: NSIndexPath,
                                                 toIndexPath destinationIndexPath: NSIndexPath) {
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
        let numberOfCells = controller?.numberOfCellsInCollectionView()
        
        if numberOfCells >= selectedCellIndexPath.item {
            return true
        }else{
            return false
        }
    }
    
    func seekBarUpdateHandler(value: Float) {
        let seekBarValue = Double(value) * getCompositionDuration()
        var cellPosition = 0
        
        for time in stopList{
            if (seekBarValue < time){
                if cellPosition == selectedCellIndexPath.item {
                    return
                }else{
                    updateSelectedCellUI(NSIndexPath(forItem: cellPosition, inSection: 0))
                    return
                }
            }
            cellPosition += 1
        }
    }
    
    func removeVideoClip(position: Int) {
        videoToRemove = position
        
        controller?.showAlertRemove(Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_TITLE),
                                    message: Utils().getStringByKeyFromEditor(EditorTextConstants.REMOVE_CLIP_ALERT_MESSAGE),
                                    yesString: Utils().getStringByKeyFromEditor(EditorTextConstants.YES_ACTION))
    }
    
    func removeVideoClipAfterConfirmation() {
        interactor?.removeVideo(videoToRemove)
        
        self.reloadPositionNumberAfterMovement()
    }
    
    //MARK: - Inner functions
    func moveClipToPosition(sourcePosition:Int,
                            destionationPosition:Int){
        interactor?.moveClipToPosition(sourcePosition,
                                       destionationPosition: destionationPosition)
    }
    
    func reloadPositionNumberAfterMovement() {
        interactor?.reloadPositionNumberAfterMovement()

        loadVideoListFromProject()
        
        self.setVideoDataToView()
        
        selectedCellIndexPath = NSIndexPath(forRow: 0, inSection: 0)
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
    
    func updateSelectedCellUI(indexPath:NSIndexPath){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.controller?.deselectCell(self.selectedCellIndexPath)
            self.controller?.selectCell(indexPath)
            self.selectedCellIndexPath = indexPath
        })
    }
    
    //MARK: - Interactor delegate
    func setVideoList(list: [EditorViewModel]) {
        controller?.setVideoList(list)
        self.setVideoDataToView()
    }
    
    func setStopTimeList(list: [Double]) {
        self.stopList = list
    }
    
    func updateViewList() {
        controller?.dissmissAlertController()
        
        self.loadVideoListFromProject()
    }
    
    func seekToTimeOfVideoSelectedReceiver(time:Float){
        playerPresenter?.seekToTime(time)
    }
    
    func setComposition(composition: VideoComposition) {
        playerPresenter?.createVideoPlayer(composition)
    }
}