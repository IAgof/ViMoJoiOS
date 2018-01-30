//
//  DuplicateViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 4/8/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import NMRangeSlider
import VideonaProject
import AVFoundation
import VideonaProject

class DuplicateViewController: ViMoJoController, DuplicateInterface, DuplicatePresenterDelegate, PlayerViewSetter, FullScreenWireframeDelegate {
    // MARK: - VIPER variables
    var eventHandler: DuplicatePresenterInterface?
    var wireframe: DuplicateWireframe?
    var playerHandler: PlayerPresenterInterface?

    // MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBOutlet weak var cloneYourClipLabel: UILabel!
    @IBOutlet weak var numberOfDuplicates: UILabel!

    @IBOutlet weak var thumbRight: UIImageView!
    @IBOutlet weak var thumbLeft: UIImageView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    override var forcePortrait: Bool {
        return true
    }

    // MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        numberOfDuplicates.adjustsFontSizeToFitWidth = true
		UIApplication.shared.statusBarView?.backgroundColor = configuration.mainColor
        numberOfDuplicates.textColor = configuration.mainColor
    }

    override func viewWillDisappear(_ animated: Bool) {
        eventHandler?.viewWillDissappear()
		configureNavigationBarVissible()
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarHidden()
		wireframe?.presentPlayerInterface()
    }

	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		thumbLeft.layer.cornerRadius = self.thumbLeft.frame.width / 2.0
		thumbRight.layer.cornerRadius = self.thumbRight.frame.width / 2.0
	}

    // MARK: - Actions
    @IBAction func pushCancelButton(_ sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }

    @IBAction func pushAcceptButton(_ sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }

    override func pushBack() {
        eventHandler?.pushBack()
    }

    @IBAction func pushPlusClips(_ sender: AnyObject) {
        eventHandler?.pushPlusClips()
    }

    @IBAction func pushLessClips(_ sender: AnyObject) {
        eventHandler?.pushLessClips()
    }

    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }

    // MARK: - Interface
    func cameFromFullScreenPlayer(_ playerView: PlayerView) {
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        playerHandler?.layoutSubViews()
    }

    // MARK: - Presenter delegate
    func getThumbSize() -> CGRect {
        return thumbLeft.frame
    }

    func hideMinusButton() {
        minusButton.isHidden = true
    }

    func showMinusButton() {
        minusButton.isHidden = false
    }

    func bringToFrontExpandPlayerButton() {
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }

    func setNumberDuplicates(_ text: String) {
        self.numberOfDuplicates.text = text
    }

    func setCloneYourClipText(_ text: String) {
        self.cloneYourClipLabel.text = text
    }

    func setThumbnails(_ image: UIImage) {
        thumbLeft.image = image

        thumbRight.image = image

        numberOfDuplicates.frame = CGRect(x: numberOfDuplicates.frame.origin.x,
                                              y: numberOfDuplicates.frame.origin.y,
                                              width: 20,
                                              height: numberOfDuplicates.frame.height)
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

    func setStopToVideo() {
        playerHandler?.onVideoStops()
    }

    func updatePlayerOnView(_ composition: VideoComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }

    func trackNumberOfDuplicates(numberOfDuplicates number: Int) {
        ViMoJoTracker.sharedInstance.trackClipDuplicated(number)
    }

    // MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
