//
//  SplitViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import NMRangeSlider
import VideonaPlayer
import AVFoundation
import VideonaSplit
import VideonaProject

class SplitViewController: ViMoJoController,SplitViewInterface,SplitPresenterDelegate,PlayerViewDelegate,PlayerViewSetter {
    //MARK: - VIPER variables
    var eventHandler: SplitPresenterInterface?
    var wireframe: SplitWireframe?
    var playerHandler: PlayerPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var splitYourClipLabel: UILabel!
    @IBOutlet weak var timeToCutLabel: UILabel!
    
    @IBOutlet weak var splitRangeSlider: NMRangeSlider!

    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        eventHandler?.viewWillDissappear()
    }
    
    //MARK: - Actions
    @IBAction func pushCancelButton(_ sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }
    
    @IBAction func pushAcceptButton(_ sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
    
    @IBAction func pushBackBarButton(_ sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    @IBAction func labelSliderChanged(_ sender: NMRangeSlider) {
        
        eventHandler?.setSplitValue(splitRangeSlider.upperValue)
    }
    
    @IBAction func labelSliderPushed(_ sender: NMRangeSlider) {
        
        eventHandler?.setSplitValue(splitRangeSlider.upperValue)
    }
    
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    //MARK: - Interface
    func configureRangeSlider(_ splitValue: Float,
                              maximumValue:Float) {
        
        self.configureUIRangeSlider()
        
        splitRangeSlider.maximumValue = maximumValue
        splitRangeSlider.minimumValue = 0.0
        
        splitRangeSlider.lowerHandleHidden = true
        splitRangeSlider.upperValue = splitValue
        
        Utils.sharedInstance.debugLog("maximum value\(splitRangeSlider.maximumValue) \n upper value\(splitRangeSlider.upperValue)")
    }
    
    func configureUIRangeSlider(){

        var trackBackgroundImage = UIImage(named: "button_edit_seekbar_background_split")
        trackBackgroundImage = trackBackgroundImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5.0, 0.0, 5.0))
        splitRangeSlider.trackBackgroundImage = trackBackgroundImage
        
        var handleImage = UIImage(named: "button_edit_thumb_seekbar_over_advance_split")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        splitRangeSlider.upperHandleImageNormal = handleImage

        let handleImagePressed = UIImage(named: "button_edit_thumb_seekbar_advance_split_pressed")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        splitRangeSlider.upperHandleImageHighlighted = handleImagePressed
        
    }
    
    func setSliderValue(_ value:Float){
        splitRangeSlider.upperValue = value
    }
    
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(_ playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        playerHandler?.layoutSubViews()
    }
    
    //MARK: - Presenter delegate
    func setSplitValueText(_ text: String) {
        self.timeToCutLabel.text = text
    }
    
    func acceptFinished() {
        ViMoJoTracker.sharedInstance.trackClipSplitted()
        
        wireframe?.goPrevController()
    }
    
    func pushBackFinished() {
        wireframe?.goPrevController()
    }
    
    func expandPlayerToView() {
        wireframe?.presentExpandPlayer()
    }
    
    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }
    
    func updatePlayerOnView(_ composition: VideoComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }
    
    func setPlayerToSeekTime(_ time: Float) {
        playerHandler?.seekToTime(time)
    }
    
    //MARK: - Player view delegate
    func seekBarUpdate(_ value: Float) {
        eventHandler?.updateSplitValueByPlayer(value)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
