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
import VideonaPlayer
import AVFoundation
import VideonaDuplicate

class DuplicateViewController: ViMoJoController,DuplicateInterface,DuplicatePresenterDelegate,PlayerViewSetter,FullScreenWireframeDelegate {
    //MARK: - VIPER variables
    var eventHandler: DuplicatePresenterInterface?
    var wireframe: DuplicateWireframe?
    var playerHandler: PlayerPresenterInterface?

    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    @IBOutlet weak var cloneYourClipLabel: UILabel!
    @IBOutlet weak var numberOfDuplicates: UILabel!

    @IBOutlet weak var thumbRight: UIImageView!
    @IBOutlet weak var thumbLeft: UIImageView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
        numberOfDuplicates.adjustsFontSizeToFitWidth = true
        wireframe?.presentPlayerInterface()
    }
    
    override func viewWillDisappear(animated: Bool) {
        eventHandler?.viewWillDissappear()
    }
    
    //MARK: - Actions
    @IBAction func pushCancelButton(sender: AnyObject) {
        eventHandler?.pushCancelHandler()
    }
    
    @IBAction func pushAcceptButton(sender: AnyObject) {
        eventHandler?.pushAcceptHandler()
    }
    
    @IBAction func pushBackBarButton(sender: AnyObject) {
        eventHandler?.pushBack()
    }
    
    @IBAction func pushPlusClips(sender: AnyObject) {
        eventHandler?.pushPlusClips()
    }
    
    @IBAction func pushLessClips(sender: AnyObject) {
        eventHandler?.pushLessClips()
    }
    
    @IBAction func pushExpandButton(sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    //MARK: - Interface
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
        playerHandler?.layoutSubViews()
    }
    
    //MARK: - Presenter delegate
    func getThumbSize()->CGRect{
        return thumbLeft.frame
    }
    
    func hideMinusButton(){
        minusButton.hidden = true
    }
    
    func showMinusButton(){
        minusButton.hidden = false
    }
    
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func setNumberDuplicates(text: String) {
        self.numberOfDuplicates.text = text
    }
    
    func setCloneYourClipText(text: String) {
        self.cloneYourClipLabel.text = text
    }
    
    func setThumbnails(image:UIImage){
        thumbLeft.image = image
        
        thumbRight.image = image
        
        numberOfDuplicates.frame = CGRectMake(numberOfDuplicates.frame.origin.x,
                                              numberOfDuplicates.frame.origin.y,
                                              20,
                                              numberOfDuplicates.frame.height)
    }
    
    func acceptFinished() {
        //        ViMoJoTracker.sharedInstance.trackClipDuplicated(3)

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
    
    func updatePlayerOnView(composition: AVMutableComposition) {
        self.playerHandler?.createVideoPlayer(composition)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}