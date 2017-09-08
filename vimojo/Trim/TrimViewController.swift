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
import VideonaProject
import AVFoundation
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
    
    @IBOutlet weak var trimBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var minRangeLabel: UILabel!
    @IBOutlet weak var maxRangeLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    @IBOutlet weak var trimTitleLabel: UILabel!
    
    @IBOutlet weak var expandPlayerButton: UIButton!

    @IBOutlet weak var milisecondsLowButton: UIButton!
    @IBOutlet weak var milisecondsMediumButton: UIButton!
    @IBOutlet weak var milisecondsHighButton: UIButton!
    
	@IBOutlet weak var milisecondsLeftDecreaseButton: UIButton!
	@IBOutlet weak var milisecondsLeftIncreaseButton: UIButton!
	@IBOutlet weak var milisecondsRightDecreaseButton: UIButton!
	@IBOutlet weak var milisecondsRightIncreaseButton: UIButton!
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        wireframe?.presentPlayerInterface()
        
        trimRangeSlider.addTarget(self, action: #selector(TrimViewController.sliderBeganTracking),
                             for: UIControlEvents.touchDown)
        trimRangeSlider.addTarget(self, action: #selector(TrimViewController.sliderEndedTracking),
                                  for: UIControlEvents.touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDissappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBarWithBackButton()
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
    
    override func pushBack() {
        eventHandler?.pushBack()
    }
   
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
	
	enum playerAdvanceTrimming {
		case lowLeft
		case lowLeftPressed
		case lowRight
		case lowRightPressed
		case mediumLeft
		case mediumLeftPressed
		case mediumRight
		case mediumRightPressed
		case highLeft
		case highLeftPressed
		case highRight
		case highRightPressed
		
		func getImage() -> UIImage {
			switch self {
			case .lowLeft:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_low")
			case .lowLeftPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_low_pressed")
			case .lowRight:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_low")
			case .lowRightPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_low_pressed")
			case .mediumLeft:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_medium")
			case .mediumLeftPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_medium_pressed")
			case .mediumRight:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_medium")
			case .mediumRightPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_medium_pressed")
			case .highLeft:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_high")
			case .highLeftPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_left_high_pressed")
			case .highRight:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_high")
			case .highRightPressed:
				return #imageLiteral(resourceName: "activity_edit_player_advance_right_high_pressed")
				
			}
		}
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
        
//        let trackImage = #imageLiteral(resourceName: "common_icon_trim_bar_pressed")
//        trimRangeSlider.trackImage = trackImage
        
        let handleImage = #imageLiteral(resourceName: "activity_edit_clips_trim_bar_normal")
        trimBarHeightConstraint.constant = handleImage.size.height
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
    
    func milisecondsLowSelect() {
        milisecondsLowButton.isSelected = true
    }
    
    func milisecondsLowUnselect() {
        milisecondsLowButton.isSelected = false
    }
    
    func milisecondsMediumSelect() {
        milisecondsMediumButton.isSelected = true
    }
    
    func milisecondsMediumUnselect() {
        milisecondsMediumButton.isSelected = false
    }
    
    func milisecondsHighSelect() {
        milisecondsHighButton.isSelected = true
    }
	
    func milisecondsHighUnselect() {
        milisecondsHighButton.isSelected = false
    }
	
	func swapImageLow() {
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.lowLeft.getImage(), for: .normal)
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.lowLeftPressed.getImage(), for: .highlighted)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.lowRight.getImage(), for: .normal)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.lowRightPressed.getImage(), for: .highlighted)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.lowLeft.getImage(), for: .normal)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.lowLeftPressed.getImage(), for: .highlighted)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.lowRight.getImage(), for: .normal)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.lowRightPressed.getImage(), for: .highlighted)
	}
	
	func swapImageMedium() {
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.mediumLeft.getImage(), for: .normal)
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.mediumLeftPressed.getImage(), for: .highlighted)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.mediumRight.getImage(), for: .normal)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.mediumRightPressed.getImage(), for: .highlighted)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.mediumLeft.getImage(), for: .normal)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.mediumLeftPressed.getImage(), for: .highlighted)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.mediumRight.getImage(), for: .normal)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.mediumRightPressed.getImage(), for: .highlighted)
	}
	
	func swapImageHigh() {
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.highLeft.getImage(), for: .normal)
		milisecondsLeftDecreaseButton.setImage(playerAdvanceTrimming.highLeftPressed.getImage(), for: .highlighted)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.highRight.getImage(), for: .normal)
		milisecondsLeftIncreaseButton.setImage(playerAdvanceTrimming.highRightPressed.getImage(), for: .highlighted)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.highLeft.getImage(), for: .normal)
		milisecondsRightDecreaseButton.setImage(playerAdvanceTrimming.highLeftPressed.getImage(), for: .highlighted)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.highRight.getImage(), for: .normal)
		milisecondsRightIncreaseButton.setImage(playerAdvanceTrimming.highRightPressed.getImage(), for: .highlighted)
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
    
    @IBAction func pushLeftDecreaseTime(_ sender: AnyObject) {
        eventHandler?.setTrimLeftDecreaseTime()
    }
    
    @IBAction func pushLeftIncreaseTime(_ sender: AnyObject) {
        eventHandler?.setTrimLeftIncreaseTime()
    }
    
    @IBAction func pushRightDecreaseTime(_ sender: AnyObject) {
        eventHandler?.setTrimRightDecreaseTime()
    }
    
    @IBAction func pushRightIncreaseTime(_ sender: AnyObject) {
        eventHandler?.setTrimRightIncreaseTime()
    }
    
    @IBAction func pushMilisecondsLow(_ sender: AnyObject) {
        eventHandler?.setMilisecondsLow()
    }
    
    @IBAction func pushMilisecondsMedium(_ sender: AnyObject) {
        eventHandler?.setMilisecondsMedium()
    }
    
    @IBAction func pushMilisecondsHigh(_ sender: AnyObject) {
        eventHandler?.setMilisecondsHigh()
    }
}
