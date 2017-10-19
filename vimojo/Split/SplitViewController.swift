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
import VideonaProject
import AVFoundation
import VideonaProject

class SplitViewController: ViMoJoController, SplitViewInterface, SplitPresenterDelegate, PlayerViewDelegate, PlayerViewSetter {
    // MARK: - VIPER variables
    var eventHandler: SplitPresenterInterface?
    var wireframe: SplitWireframe?
    var playerHandler: PlayerPresenterInterface?

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var expandPlayerButton: UIButton!
    @IBOutlet weak var splitRangeSlider: TTRangeSlider!
    @IBOutlet weak var splitView: UIView!
	@IBOutlet weak var lowMilisecondsLabel: UILabel!
	@IBOutlet weak var mediumMilisecondsLabel: UILabel!
	@IBOutlet weak var highMilisecondsLabel: UILabel!
	
    override var forcePortrait: Bool {
        return true
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.viewDidLoad()
        UIApplication.shared.statusBarView?.backgroundColor = configuration.mainColor
		splitRangeSlider.delegate = self
    }
	
	override func viewDidLayoutSubviews() {
		let splitRangeSliderHeight:CGFloat = splitRangeSlider.bounds.size.height
		eventHandler?.viewDidLayoutSubviews(splitRangeSliderHeight)
	}
	
	func updateSplitRangeSliderDiameter(_ value: CGFloat) {
		splitRangeSlider.handleDiameter = value
	}

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDissappear()
		configureNavigationBarVissible()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		wireframe?.presentPlayerInterface()
		configureNavigationBarHidden()
    }

    // MARK: - Actions
    @IBAction func pushCancelButton(_ sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }

    @IBAction func pushAcceptButton(_ sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }

    @IBAction func pushAdvanceLeftLow(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateLeftLowValue()
    }

    @IBAction func pushAdvanceLeftMedium(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateLeftMediumValue()
    }

    @IBAction func pushAdvanceLeftHigh(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateLeftHighValue()
    }

    @IBAction func pushAdvanceRightHigh(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateRightHighValue()
    }

    @IBAction func pushAdvanceRightMedium(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateRightMediumValue()
    }

    @IBAction func pushAdvanceRightLow(_ sender: AnyObject) {
        eventHandler?.setSplitAccurateRightLowValue()
    }

    override func pushBack() {
        eventHandler?.pushBack()
    }

    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }

    // MARK: - Interface
    func configureRangeSlider(_ splitValue: Float,
                              maximumValue: Float) {

        self.configureUIRangeSlider()

        splitRangeSlider.maxValue = maximumValue
        splitRangeSlider.minValue = 0.0

        splitRangeSlider.selectedMaximum = splitValue
        splitRangeSlider.selectedMinimum = 0
    }

    func configureUIRangeSlider() {
        splitRangeSlider.tintColor = configuration.secondColorWithOpacity
        splitRangeSlider.backgroundColor = configuration.secondColorWithOpacity
        splitRangeSlider.maxLabelColour = configuration.secondColor
        splitRangeSlider.lineHeight = 0

        let handleImage = UIImage(named: "button_edit_thumb_seekbar_advance_split_normal")
        splitRangeSlider.handleImage = handleImage

        let formatter = TimeNumberFormatter()
        self.splitRangeSlider.numberFormatterOverride = formatter

		splitRangeSlider.selectedHandleDiameterMultiplier = 1
    }

    func setSliderValue(_ value: Float) {
        splitRangeSlider.selectedMaximum = value
    }

    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }

    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        playerHandler?.layoutSubViews()
    }

    // MARK: - Presenter delegate    
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

    // MARK: - Player view delegate
    func seekBarUpdate(_ value: Float) {
        eventHandler?.updateSplitValueByPlayer(value)
    }

    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension SplitViewController:TTRangeSliderDelegate {
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        debugPrint("Maximum value \(selectedMaximum)")
        eventHandler?.setSplitValue(selectedMaximum)
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
