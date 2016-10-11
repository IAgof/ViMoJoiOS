//
//  MicRecorderViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

class MicRecorderViewController: ViMoJoController,MicRecorderPresenterDelegate,PlayerViewSetter{
    //MARK: - VIPER variables
    var eventHandler: MicRecorderPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    
    //MARK: - Variables and constants
    var micRecorderView:MicRecorderViewInterface?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.viewWillAppear()
    }
    
    override func viewDidAppear(animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func pushBackButton(sender: AnyObject) {
        eventHandler?.pushBackButton()
    }
    //MARK: - Presenter delegate
    func showMicRecordView(micRecorderViewModel: MicRecorderViewModel) {
        let view = MicRecorderView.instanceFromNib() as? MicRecorderView
        micRecorderView = view
        view?.delegate = self
        
        musicContainer.addSubview(view!)
        view?.setViewFrame(musicContainer.frame)
        
        micRecorderView?.setLowValueLabelString(micRecorderViewModel.lowValue)
        micRecorderView?.setHighValueLabelString(micRecorderViewModel.highValue)
        micRecorderView?.setActualValueLabelString(micRecorderViewModel.actualValue)
        micRecorderView?.configureRangeSlider()
    }
    
    func hideMicRecordView() {
        micRecorderView?.removeView()
    }
    
    func showAcceptCancelButton() {
        micRecorderView?.showButtons()
    }
    
    func hideAcceptCancelButton() {
        micRecorderView?.hideButtons()
    }
    
    //MARK: - Change views
    func setMicRecorderButtonState(state: Bool) {
        micRecorderView?.setRecordButtonSelectedState(state)
    }
    
    func setMicRecorderButtonEnabled(state: Bool) {
        micRecorderView?.setRecordButtonEnable(state)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension MicRecorderViewController:MicRecorderViewDelegate{
    func micRecorderLongPressStart(){
        eventHandler?.startLongPress()
    }
    
    func micRecorderLongPressFinished(){
        eventHandler?.pauseLongPress()
    }
    
    func micRecorderAcceptButtonPushed(){
        eventHandler?.acceptMicRecord()
    }
    
    func micRecorderCancelButtonPushed(){
        eventHandler?.cancelMicRecord()
    }
    
    func updateRecordMicActualTime(time: String) {
        micRecorderView?.setActualValueLabelString(time)
    }
}

extension MicRecorderViewController:PlayerViewDelegate{
    func seekBarUpdate(value: Float) {
        micRecorderView?.updateSliderTo(value)
        eventHandler?.updateActualTime(value)
    }
}

extension MicRecorderViewController:PlayerViewFinishedDelegate{
    func playerHasLoaded() {
        eventHandler?.playerHasLoaded()
    }
}