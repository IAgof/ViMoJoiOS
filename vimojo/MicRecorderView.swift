//
//  MicRecorderView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 10/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import NMRangeSlider
import VideonaProject
import VideonaTrackOverView

protocol MicRecorderViewDelegate {
    func micRecorderLongPressStart()
    func micRecorderLongPressFinished()
    func micRecorderAcceptButtonPushed()
    func micRecorderCancelButtonPushed()
    func micSliderInserctionPointValueChanged(value:Float)
}

protocol MicRecorderViewInterface {
    func setRecordButtonSelectedState(_ state:Bool)
    func setRecordButtonEnable(_ state:Bool)
    func setLowValueLabelString(_ text:String)
    func setHighValueLabelString(_ text:String)
    func setActualValueLabelString(_ text:String)
    func configureRangeSlider(_ maximumValue:Float)
    func setSliderEnableState(isEnabled:Bool)
    func updateSliderTo(_ value:Float)
    func removeView()
    func showButtons()
    func hideButtons()
    
    func addTrackedArea(values:TrackModel)
    func removeTrackedArea(position:Int)
    func updateTrackedArea(position:Int,
                           values:TrackModel)
}

class MicRecorderView: UIView,MicRecorderViewInterface{
    
    //MARK: - Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var lowValueLabel: UILabel!
    @IBOutlet weak var actualValueLabel: UILabel!
    @IBOutlet weak var highValueLabel: UILabel!
    @IBOutlet weak var totalRecordedSlider: NMRangeSlider!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var recordedTrackOverView: VideonaTrackOverView!
    
    //MARK: - Variables
    var delegate:MicRecorderViewDelegate?
    var longPressGesture: UILongPressGestureRecognizer?

    //MARK: - Init
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MicRecorderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MicRecorderView.handleLongGesture(_:)))
        self.recordButton.addGestureRecognizer(longPressGesture!)
        
        configureUIRangeSlider()
    }
    
    func setViewFrame(_ frame:CGRect){
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    //MARK: - Actions
    @IBAction func acceptButtonPushed(_ sender: AnyObject) {
        delegate?.micRecorderAcceptButtonPushed()
    }
    
    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        delegate?.micRecorderCancelButtonPushed()
    }
    
    //MARK: - Drag and Drop handler
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            delegate?.micRecorderLongPressStart()
            break
        case UIGestureRecognizerState.changed:
           
            break
        case UIGestureRecognizerState.ended:
            delegate?.micRecorderLongPressFinished()
            break

        default:
            break
        }
    }
    
    
    @IBAction func micSliderChanged(_ sender: NMRangeSlider) {
        delegate?.micSliderInserctionPointValueChanged(value: totalRecordedSlider.upperValue)
    }
    
    //MARK: - Interface
    func setRecordButtonSelectedState(_ state: Bool) {
        recordButton.isSelected = state
    }
    
    func setRecordButtonEnable(_ state: Bool) {
        longPressGesture?.isEnabled = state
        recordButton.isEnabled = state
    }
    
    func setLowValueLabelString(_ text: String) {
        lowValueLabel.text = text
    }
    
    func setActualValueLabelString(_ text: String) {
        actualValueLabel.text = text
    }
    
    func setHighValueLabelString(_ text: String) {
        highValueLabel.text = text
    }
    
    func configureRangeSlider(_ maximumValue:Float) {
        
        self.configureUIRangeSlider()
        
        totalRecordedSlider.maximumValue = maximumValue
        totalRecordedSlider.minimumValue = 0.0
        
        totalRecordedSlider.lowerHandleHidden = true
        totalRecordedSlider.upperValue = 0.0
        
        Utils().debugLog("maximum value\(totalRecordedSlider.maximumValue) \n upper value\(totalRecordedSlider.upperValue)")
    }
    
    func removeView() {
        self.removeFromSuperview()
    }
    
    func showButtons(){
        acceptButton.isHidden = false
        cancelButton.isHidden = false
    }

    func hideButtons() {
        acceptButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    func updateSliderTo(_ value: Float) {
        totalRecordedSlider.upperValue = value
    }
    
    func setSliderEnableState(isEnabled: Bool) {
        totalRecordedSlider.isEnabled = isEnabled
    }
    
    func addTrackedArea(values: TrackModel) {
        recordedTrackOverView.addLayer(portionData: values)
    }
    
    func removeTrackedArea(position: Int) {
        recordedTrackOverView.removeLayerFromPosition(position: position)
    }
    
    func updateTrackedArea(position: Int, values: TrackModel) {
        recordedTrackOverView.updateLayer(portionData: values, position: position)
    }
    
    //MARK: - Range UI Config
    func configureUIRangeSlider(){
        
        var trackBackgroundImage = UIImage(named: "button_edit_seekbar_background_split")
        trackBackgroundImage = trackBackgroundImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 5.0, 0.0, 5.0))
        totalRecordedSlider.trackBackgroundImage = trackBackgroundImage
        
        var handleImage = UIImage(named: "button_edit_thumb_seekbar_advance_split_normal")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageNormal = handleImage
        
        let handleImagePressed = UIImage(named: "button_edit_thumb_seekbar_advance_split_pressed")
        handleImage = handleImage?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageHighlighted = handleImagePressed
    }
}
