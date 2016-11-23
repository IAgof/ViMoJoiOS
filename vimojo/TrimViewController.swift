//
//  TrimViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import NMRangeSlider
import VideonaPlayer
import AVFoundation
import VideonaTrim
import VideonaProject

class TrimViewController: ViMoJoController,TrimPresenterDelegate,PlayerViewSetter,FullScreenWireframeDelegate{
    //MARK: - VIPER variables
    var eventHandler: TrimPresenterInterface?
    var wireframe: TrimWireframe?
    var playerHandler: PlayerPresenterInterface?

    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var trimRangeSlider: NMRangeSlider!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    @IBOutlet weak var minRangeLabel: UILabel!
    @IBOutlet weak var maxRangeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!

    @IBOutlet weak var trimTitleLabel:   UILabel!
    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
        
        trimRangeSlider.addTarget(self, action: #selector(TrimViewController.sliderBeganTracking),
                             for: UIControlEvents.touchDown)
        trimRangeSlider.addTarget(self, action: #selector(TrimViewController.sliderEndedTracking),
                                  for: UIControlEvents.touchUpInside)
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
        ViMoJoTracker.sharedInstance.trackClipTrimmed()
    }
    
    @IBAction func labelSliderChanged(_ sender: NMRangeSlider) {
        eventHandler?.setLowerValue(trimRangeSlider.lowerValue)
        eventHandler?.setUpperValue(trimRangeSlider.upperValue)
    }
    
    @IBAction func pushBackBarButton(_ sender: AnyObject) {
        eventHandler?.pushBack()
    }
   
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    //MARK: - Presenter delegate
    func configureRangeSlider(_ lowerValue: Float,
                              upperValue: Float,
                              maximumValue:Float) {
        
        self.configureUIRangeSlider()
        
        trimRangeSlider.maximumValue = maximumValue
        trimRangeSlider.minimumValue = 0.0
        
        trimRangeSlider.upperValue = upperValue
        trimRangeSlider.lowerValue = lowerValue
        
        Utils().debugLog("maximum value\(trimRangeSlider.maximumValue) \n upper value\(trimRangeSlider.upperValue)")
        Utils().debugLog("maximum value\(trimRangeSlider.minimumValue) \nlower value\(trimRangeSlider.lowerValue)")
    }
    
    func configureUIRangeSlider(){
        
        let trackImage = UIImage(named: "button_edit_thumb_seekbar_trim_normal")
        trimRangeSlider.trackImage = trackImage
        
        let handleImage = UIImage(named: "button_edit_thumb_seekbar_trim_pressed")
        trimRangeSlider.lowerHandleImageNormal = handleImage
        trimRangeSlider.upperHandleImageNormal = handleImage
        
        trimRangeSlider.lowerHandleImageHighlighted = handleImage
        trimRangeSlider.upperHandleImageHighlighted = handleImage
    }
    
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(_ playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        playerHandler?.layoutSubViews()
    }
    
    func setMaxRangeValue(_ text: String) {
        self.maxRangeLabel.text = text
    }
    func setMinRangeValue(_ text: String) {
        self.minRangeLabel.text = text
    }
    func setRangeValue(_ text: String) {
        self.rangeLabel.text = text
    }
    
    func setTitleTrimLabel(_ text:String){
        self.trimTitleLabel.text = text
    }
    
    func acceptFinished() {
        wireframe?.goPrevController()
    }
    
    func pushBackFinished() {
        wireframe?.goPrevController()
    }
    
    func expandPlayerToView() {
        wireframe?.presentExpandPlayer()
    }
    
    func setPlayerToSeekTime(_ time: Float) {
        playerHandler?.seekToTime(time)
    }
    
    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }
    
    func updatePlayerOnView(_ composition: VideoComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }
    
    //MARK: Inner functions
    func sliderBeganTracking(){
        eventHandler?.trimSliderBegan()
    }
    func sliderEndedTracking(){
        eventHandler?.trimSliderEnded()
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
