//
//  SplitViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import TTRangeSlider
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
    @IBOutlet weak var expandPlayerButton: UIButton!

    @IBOutlet weak var splitYourClipLabel: UILabel!

    
    @IBOutlet weak var splitRangeSlider: TTRangeSlider!


    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
        splitRangeSlider.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        eventHandler?.viewWillDissappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithBackButton()
    }
    
    //MARK: - Actions
    @IBAction func pushCancelButton(_ sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }
    
    @IBAction func pushAcceptButton(_ sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
    
    override func pushBack() {
        eventHandler?.pushBack()
    }
    
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    //MARK: - Interface
    func configureRangeSlider(_ splitValue: Float,
                              maximumValue:Float)
    {
        
        self.configureUIRangeSlider()
        
        splitRangeSlider.maxValue = maximumValue
        splitRangeSlider.minValue = 0.0
        
        splitRangeSlider.selectedMaximum = splitValue
        splitRangeSlider.selectedMinimum = 0
    }

    func configureUIRangeSlider(){
        splitRangeSlider.tintColor = configuration.secondColorWithOpacity
        splitRangeSlider.backgroundColor = configuration.secondColorWithOpacity
        splitRangeSlider.maxLabelColour = configuration.secondColor
        splitRangeSlider.lineHeight = 0
        
        let handleImage = UIImage(named: "button_edit_thumb_seekbar_advance_split_normal")
        splitRangeSlider.handleImage = handleImage
        
        let formatter = TimeNumberFormatter()
        self.splitRangeSlider.numberFormatterOverride = formatter
    }
    
    func setSliderValue(_ value:Float){
        splitRangeSlider.selectedMaximum = value
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

extension SplitViewController:TTRangeSliderDelegate{
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        debugPrint("Maximum value \(selectedMaximum)")
        eventHandler?.setSplitValue(selectedMaximum)
    }
}
