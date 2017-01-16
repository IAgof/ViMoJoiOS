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
import TTRangeSlider
import VideonaProject

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
    @IBOutlet weak var totalRecordedSlider: TTRangeSlider!
    @IBOutlet weak var recordedTrackOverView: VideonaTrackOverView!
    
    @IBOutlet weak var deleteVoiceOverTrackButton: UIButton!
    
    //MARK: - Variables and constants
    var audioPlayer:AVPlayer?
    var longPressGesture: UILongPressGestureRecognizer?
    var hasRecordViews:[UIView] = []
    
    //MARK: - Actions
    @IBAction func acceptButtonPushed(_ sender: AnyObject) {
        //TODO: assign function on eventhandler
        eventHandler?.acceptPushed()
    }
    
    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        //TODO: assign function on eventhandler
        eventHandler?.cancelPushed()
    }
    
    @IBAction func mixAudioValueChanged(_ sender: AnyObject) {
        sliderValueLabel.text = "\(Int(mixAudioSlider.value * 100))%"
        eventHandler?.mixVolumeUpdate(mixAudioSlider.value)
    }

    @IBAction func pushBackButton(_ sender: AnyObject) {
        eventHandler?.pushBackButton()
    }
    @IBAction func deleteVoiceOverTrackPushed(_ sender: Any) {
        eventHandler?.removeVoiceOverTrack()
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
    override public var supportedInterfaceOrientations : UIInterfaceOrientationMask {
            return UIInterfaceOrientationMask.portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MicRecorderViewController.handleLongGesture(_:)))
        self.recordButton.addGestureRecognizer(longPressGesture!)
        
        configureUIRangeSlider()
        totalRecordedSlider.delegate = self
        eventHandler?.viewDidLoad()
        setUpHasRecordView()
        
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
        totalRecordedSlider.tintColor = secondColor
        totalRecordedSlider.backgroundColor = secondColor
        totalRecordedSlider.maxLabelColour = secondColor
        
        let handleImage = UIImage(named: "button_edit_thumb_seekbar_advance_split_normal")
        totalRecordedSlider.handleImage = handleImage
        
        let formatter = TimeNumberFormatter()
        self.totalRecordedSlider.numberFormatterOverride = formatter
    }
    
    func configureRangeSlider(_ maximumValue:Float) {
        
        self.configureUIRangeSlider()
        
        totalRecordedSlider.maxValue = maximumValue
        totalRecordedSlider.minValue = 0.0
        
        totalRecordedSlider.selectedMaximum = 0.0
        totalRecordedSlider.selectedMinimum = 0
    }
    
    func setUpHasRecordView(){
        hasRecordViews.append(mixAudioSlider)
        hasRecordViews.append(sliderValueLabel)
    }
}

extension MicRecorderViewController:MicRecorderPresenterDelegate{
    //MARK: - Presenter delegate
    func setUpValues(_ micRecorderViewModel: MicRecorderViewModel) {
        lowValueLabel.text = micRecorderViewModel.lowValue
        highValueLabel.text = micRecorderViewModel.highValue
        actualValueLabel.text = micRecorderViewModel.actualValue
        configureRangeSlider(Float(micRecorderViewModel.sliderRange))
        
        mixAudioSlider.value = micRecorderViewModel.mixAudioSliderValue
        sliderValueLabel.text = "\(Int(mixAudioSlider.value * 100))%"
        eventHandler?.mixVolumeUpdate(mixAudioSlider.value)
    }

    func showHasRecordViews() {
        for view in hasRecordViews{
            if view.isHidden{
                view.fadeInViews([view])
            }
        }
    }

    func hideHasRecordViews() {
        for view in hasRecordViews{
            if !view.isHidden{
                view.fadeOutViews([view])
            }
        }
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
    
    func recordButtonIsHidden(isHidden: Bool) {
        recordButton.isHidden = isHidden
    }
    
    func deleteVoiceOverTrackButtonIsHidden(isHidden: Bool) {
        deleteVoiceOverTrackButton.isHidden = isHidden
    }
}
extension MicRecorderViewController:PlayerViewDelegate{
    func seekBarUpdate(_ value: Float) {
        totalRecordedSlider.selectedMaximum = value
        eventHandler?.updateActualTime(value)
    }
}

extension MicRecorderViewController:TTRangeSliderDelegate{
    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
        debugPrint("Maximum value \(selectedMaximum)")
        eventHandler?.micInserctionPointValue(value: selectedMaximum)
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
