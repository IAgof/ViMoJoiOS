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
import VideonaProject
import VideonaProject

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
    var stopList:[Double] = []
    var isGoingToExpandPlayer = false
    
    let option_video:String
    let option_gallery:String
    let option_add_text:String
    
    //MARK: - Inner functions
    override init() {
        option_video = EditorTextConstants.ADD_VIDEO.localize(inTable: "EditorStrings")
        option_gallery = EditorTextConstants.ADD_GALLERY.localize(inTable: "EditorStrings")
        option_add_text = EditorTextConstants.ADD_TEXT_TO_VIDEO.localize(inTable: "EditorStrings")
    }
    
    func moveClipToPosition(_ sourcePosition:Int,
                            destionationPosition:Int){
        interactor?.moveClipToPosition(sourcePosition,
                                       destionationPosition: destionationPosition)
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
            self.delegate?.selectCell(indexPath)
            self.selectedCellIndexPath = indexPath
        })
    }
    

}
extension EditorPresenter:EditorPresenterInterface{
    //MARK: - Interface
    func viewDidLoad() {
//        loadView()
    }
    
    func loadView(){
        loadVideoListFromProject()
        
        //Auto select first item on first load
        self.didSelectItemAtIndexPath(selectedCellIndexPath)
        
        delegate?.setUpGestureRecognizer()
    }
    
    func updatePlayerView(){
        wireframe?.presentPlayerInterface()
        delegate?.bringToFrontExpandPlayerButton()
    }
    
    func viewWillAppear() {                
        if !isGoingToExpandPlayer{
            self.loadView()
            
            self.playerPresenter?.onVideoStops()
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
    }
    
    func seekToSelectedItem(_ videoPosition:Int){
        interactor?.seekToSelectedItemHandler(videoPosition)
    }
    
    func moveItemAtIndexPath(_ sourceIndexPath: IndexPath,
                             toIndexPath destinationIndexPath: IndexPath) {
        self.moveClipToPosition(sourceIndexPath.item,
                                destionationPosition: destinationIndexPath.item)
        
        updateSelectedCellUI(destinationIndexPath)

        ViMoJoTracker.sharedInstance.trackClipsReordered()
    }
    
    func pushDuplicateHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentDuplicateController(selectedCellIndexPath.item)
        }
    }
    
    func pushSplitHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentSplitController(selectedCellIndexPath.item)
        }
    }
    
    func pushTrimHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentTrimController(selectedCellIndexPath.item)
        }
    }
    
    func pushAddTextHandler() {
        if checkIfSelectedCellExits() && canGoToAnyEditorAction(){
            wireframe?.presentAddTextController(selectedCellIndexPath.item)
        }
    }
    
    func pushAddFloating() {
        let title = Utils().getStringByKeyFromEditor(EditorTextConstants.ADD_TITLE)

        var addOptions:[String] = []
        addOptions.append(option_video)
        addOptions.append(option_gallery)
       
        if interactor?.getNumberOfClips() != 0{
            addOptions.append(option_add_text)
        }
        
        delegate?.createAlertWithAddOptions(title: title, options: addOptions)
    }
    
    func pushOptions() {
        wireframe?.presentSettings()
    }
    
    func addSelection(selection:String){
        switch selection {
        case option_video:
            wireframe?.presentRecorder()
            break
        case option_gallery:
            wireframe?.presentGallery()
            break
        case option_add_text:
            wireframe?.presentAddTextController(selectedCellIndexPath.item)
            break
        default:
            print("Default add selection")
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
        if let numberOfCells = delegate?.numberOfCellsInCollectionView(){
            if numberOfCells >= selectedCellIndexPath.item {
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func seekBarUpdateHandler(_ value: Float) {
        let seekBarValue = Double(value)
        var cellPosition = 0
        
        for time in stopList{
            if (seekBarValue < (time)){
                if cellPosition == selectedCellIndexPath.item {
                    return
                }else{
                    updateSelectedCellUI(IndexPath(item: cellPosition, section: 0))
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
        let prevItemSelected = max(videoToRemove - 1, 0)
        selectedCellIndexPath = IndexPath(item: prevItemSelected, section: 0)
        
        if interactor?.getNumberOfClips() == 0{
            wireframe?.presentGoToRecordOrGallery()
        }
    }
  
    func playerHasLoaded() {
        seekToSelectedItem(selectedCellIndexPath.item)
    }
}

extension EditorPresenter:EditorInteractorDelegate{
    //MARK: - Interactor delegate
    func setVideoList(_ list: [EditorViewModel]) {
        delegate?.setVideoList(list)
        
        self.delegate?.selectCell(selectedCellIndexPath)
    }
    
    func setStopTimeList(_ list: [Double]) {
        self.stopList = list
    }
    
    func seekToTimeOfVideoSelectedReceiver(_ time:Float){
        playerPresenter?.seekToTime(time)
    }
    
    func setComposition(_ composition: VideoComposition) {
        self.updatePlayerView()

        playerPresenter?.createVideoPlayer(composition)
    }
}
