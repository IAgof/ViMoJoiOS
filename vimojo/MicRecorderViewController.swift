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
import NMRangeSlider

class MicRecorderViewController: ViMoJoController,PlayerViewSetter{
    //MARK: - VIPER variables
    var eventHandler: MicRecorderPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var mixAudioSlider: UISlider!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var lowValueLabel: UILabel!
    @IBOutlet weak var actualValueLabel: UILabel!
    @IBOutlet weak var highValueLabel: UILabel!
    @IBOutlet weak var totalRecordedSlider: NMRangeSlider!
    @IBOutlet weak var recordedTrackOverView: VideonaTrackOverView!
    
    //MARK: - Variables and constants
    var audioPlayer:AVPlayer?
    var longPressGesture: UILongPressGestureRecognizer?

    //MARK: - Actions
    @IBAction func acceptButtonPushed(_ sender: AnyObject) {
        //TODO: assign function on eventhandler
    }
    
    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        //TODO: assign function on eventhandler
    }
    
    @IBAction func mixAudioValueChanged(_ sender: AnyObject) {
        sliderValueLabel.text = "\(Int(mixAudioSlider.value * 100))%"
        eventHandler?.mixVolumeUpdate(mixAudioSlider.value)
    }
    
    @IBAction func micSliderChanged(_ sender: NMRangeSlider) {
        eventHandler?.micInserctionPointValue(value: totalRecordedSlider.upperValue)
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            for view in playerView.subviews{
                if let player =  view as? PlayerView{
                    if let time = player.player?.currentTime(){
                        eventHandler?.startLongPress(atTime: time)
                        totalRecordedSlider.isEnabled = false
                    }
                }
            }
            break
        case UIGestureRecognizerState.ended:
            eventHandler?.pauseLongPress()
            totalRecordedSlider.isEnabled = true

            break
            
        default:
            break
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MicRecorderViewController.handleLongGesture(_:)))
        self.recordButton.addGestureRecognizer(longPressGesture!)
        
        configureUIRangeSlider()
        
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


    //MARK: - Change views
    func setMicRecorderButtonState(_ state: Bool) {
        recordButton.isSelected = state
    }
    
    func setMicRecorderButtonEnabled(_ state: Bool) {
        longPressGesture?.isEnabled = state
        recordButton.isEnabled = state
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
    
    //MARK: - Range UI Config
    func configureUIRangeSlider(){
        /*
        var trackBackgroundImage = UIImage(named: "button_edit_seekbar_background_split")
        trackBackgroundImage = trackBackgroundImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5.0, 0.0, 5.0))
        totalRecordedSlider.trackBackgroundImage = trackBackgroundImage
        */
        totalRecordedSlider.color
        var handleImage = UIImage(named: "button_edit_thumb_seekbar_advance_split_normal")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageNormal = handleImage
        
        let handleImagePressed = UIImage(named: "button_edit_thumb_seekbar_advance_split_pressed")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageHighlighted = handleImagePressed
    }
    
    func configureRangeSlider(_ maximumValue:Float) {
        
        self.configureUIRangeSlider()
        
        totalRecordedSlider.maximumValue = maximumValue
        totalRecordedSlider.minimumValue = 0.0
        
        totalRecordedSlider.lowerHandleHidden = true
        totalRecordedSlider.upperValue = 0.0
        
    }
}

extension MicRecorderViewController:MicRecorderPresenterDelegate{
    //MARK: - Presenter delegate
    func setUpValues(_ micRecorderViewModel: MicRecorderViewModel) {
        lowValueLabel.text = micRecorderViewModel.lowValue
        highValueLabel.text = micRecorderViewModel.highValue
        actualValueLabel.text = micRecorderViewModel.actualValue
        configureRangeSlider(Float(micRecorderViewModel.sliderRange))
    }

    func showAcceptCancelButton() {
        acceptButton.isHidden = false
        cancelButton.isHidden = false
    }

    func hideAcceptCancelButton() {
        acceptButton.isHidden = true
        cancelButton.isHidden = true
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
        recordedTrackOverView.addLayer(portionData: value)
    }

    func updateRecordedTrackArea(position: Int, value: TrackModel) {
        recordedTrackOverView.updateLayer(portionData: value, position: position)
    }

    func removeTrackArea(inPosition: Int) {
        recordedTrackOverView.removeLayerFromPosition(position: inPosition)
    }

    func updateRecordMicActualTime(_ time: String) {
        actualValueLabel.text = time
    }
}
extension MicRecorderViewController:PlayerViewDelegate{
    func seekBarUpdate(_ value: Float) {
        totalRecordedSlider.upperValue = value
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
