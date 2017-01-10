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
import AVFoundation
import VideonaTrackOverView

class MicRecorderViewController: ViMoJoController,MicRecorderPresenterDelegate,PlayerViewSetter{
    //MARK: - VIPER variables
    var eventHandler: MicRecorderPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    
    //MARK: - Variables and constants
    var micRecorderView:MicRecorderViewInterface?
    var mixAudioView:MixAudioViewInterface?
    var audioPlayer:AVPlayer?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    @IBAction func pushBackButton(_ sender: AnyObject) {
        eventHandler?.pushBackButton()
    }
    //MARK: - Presenter delegate
    func showMicRecordView(_ micRecorderViewModel: MicRecorderViewModel) {
        let view = MicRecorderView.instanceFromNib() as? MicRecorderView
        micRecorderView = view
        view?.delegate = self
        
        musicContainer.addSubview(view!)
        view?.setViewFrame(musicContainer.frame)
        
        micRecorderView?.setLowValueLabelString(micRecorderViewModel.lowValue)
        micRecorderView?.setHighValueLabelString(micRecorderViewModel.highValue)
        micRecorderView?.setActualValueLabelString(micRecorderViewModel.actualValue)
        micRecorderView?.configureRangeSlider(Float(micRecorderViewModel.sliderRange))
    }
    
    func hideMicRecordView() {
        micRecorderView?.removeView()
    }
    
    func showMixAudioView() {
        let view = MixAudioView.instanceFromNib() as? MixAudioView
        mixAudioView = view
        view?.delegate = self
        
        musicContainer.addSubview(view!)
        view?.setViewFrame(musicContainer.frame)
    }
    
    func hideMixAudioView() {
        mixAudioView?.removeView()
    }

    func showAcceptCancelButton() {
        micRecorderView?.showButtons()
    }
    
    func hideAcceptCancelButton() {
        micRecorderView?.hideButtons()
    }
    
    func changeAudioPlayerVolume(_ value: Float) {
        audioPlayer?.volume = value
    }
    
    func createAudioPlayer(_ composition: AVMutableComposition){
        let playerItem = AVPlayerItem(asset: composition)
        audioPlayer = AVPlayer(playerItem: playerItem)
    }
    
    func removeAudioPlayer() {
        audioPlayer = nil
    }
    
    func playAudioPlayer(){
        audioPlayer?.play()
    }
    
    func pauseAudioPlayer(){
        audioPlayer?.pause()
    }
    
    func seekAudioPlayerTo(_ value:Float) {
        audioPlayer?.seek(to: CMTimeMakeWithSeconds(Float64(value), 600))
    }
    
    func showAlertDiscardRecord(_ title:String,
                                message:String,
                                yesString:String) {
        
        let alertController = UIAlertController(title:title,
                                                message:message,
                                                preferredStyle: .alert)
        alertController.setTintColor()
        
        let yesAction = UIAlertAction(title: yesString,
                                      style: .default,
                                      handler: {alert -> Void in
                                        self.eventHandler?.cancelConfirmed()
        })
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: false, completion:{})
    }
    
    func setRecordedTrackArea(value: TrackModel) {
        micRecorderView?.addTrackedArea(values: value)
    }
    
    //MARK: - Change views
    func setMicRecorderButtonState(_ state: Bool) {
        micRecorderView?.setRecordButtonSelectedState(state)
    }
    
    func setMicRecorderButtonEnabled(_ state: Bool) {
        micRecorderView?.setRecordButtonEnable(state)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension MicRecorderViewController:MicRecorderViewDelegate{
    func micRecorderLongPressStart(){
        for view in playerView.subviews{
            if let player =  view as? PlayerView{
                if let time = player.player?.currentTime(){
                    eventHandler?.startLongPress(atTime: time)
                    micRecorderView?.setSliderEnableState(isEnabled: false)
                }
            }
        }
    }
    
    func micRecorderLongPressFinished(){
        eventHandler?.pauseLongPress()
        micRecorderView?.setSliderEnableState(isEnabled: true)
    }
    
    func micRecorderAcceptButtonPushed(){
        eventHandler?.acceptMicRecord()
    }
    
    func micRecorderCancelButtonPushed(){
        eventHandler?.cancelPushed()
    }
    
    func updateRecordMicActualTime(_ time: String) {
        micRecorderView?.setActualValueLabelString(time)
    }
    
    func micSliderInserctionPointValueChanged(value: Float) {
        eventHandler?.micInserctionPointValue(value: value)
    }
}

extension MicRecorderViewController:MixAudioViewDelegate{
    func mixAudioAcceptButtonPushed(){
        eventHandler?.acceptMixAudio()
    }
    func mixAudioCancelButtonPushed(){
        eventHandler?.cancelPushed()
    }
    func mixVolumeValueChanged(_ value: Float) {
        eventHandler?.mixVolumeUpdate(value)
    }
}

extension MicRecorderViewController:PlayerViewDelegate{
    func seekBarUpdate(_ value: Float) {
        micRecorderView?.updateSliderTo(value)
        eventHandler?.updateActualTime(value)
    }
}

extension MicRecorderViewController:PlayerViewFinishedDelegate{
    func playerHasLoaded() {
        eventHandler?.playerHasLoaded()
    }
    
    func playerStartsToPlay() {
        eventHandler?.videoPlayerPlay()
    }
    
    func playerPause() {
        eventHandler?.videoPlayerPause()
    }
    
    func playerSeeksTo(_ value: Float) {
        eventHandler?.videoPlayerSeeksTo(value)
    }
}
