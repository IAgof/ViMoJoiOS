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

protocol MicRecorderViewDelegate {
    func micRecorderLongPressStart()
    func micRecorderLongPressFinished()
    func micRecorderAcceptButtonPushed()
    func micRecorderCancelButtonPushed()
}

protocol MicRecorderViewInterface {
    func setRecordButtonSelectedState(state:Bool)
    func setRecordButtonEnable(state:Bool)
    func setLowValueLabelString(text:String)
    func setHighValueLabelString(text:String)
    func setActualValueLabelString(text:String)
    func configureRangeSlider()
    func updateSliderTo(value:Float)
    func removeView()
    func showButtons()
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
    
    //MARK: - Variables
    var delegate:MicRecorderViewDelegate?
    var longPressGesture: UILongPressGestureRecognizer?

    //MARK: - Init
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MicRecorderView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(MicRecorderView.handleLongGesture(_:)))
        self.recordButton.addGestureRecognizer(longPressGesture!)
        
        configureUIRangeSlider()
        totalRecordedSlider.enabled = false
    }
    
    func setViewFrame(frame:CGRect){
        self.frame = CGRectMake(0, 0, frame.width, frame.height)
    }
    
    //MARK: - Actions
    @IBAction func acceptButtonPushed(sender: AnyObject) {
        delegate?.micRecorderAcceptButtonPushed()
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        delegate?.micRecorderCancelButtonPushed()
    }
    
    //MARK: - Drag and Drop handler
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            delegate?.micRecorderLongPressStart()
            break
        case UIGestureRecognizerState.Changed:
           
            break
        case UIGestureRecognizerState.Ended:
            delegate?.micRecorderLongPressFinished()
            break

        default:
            break
        }
    }
    
    
    @IBAction func micSliderChanged(sender: NMRangeSlider) {
        
    }
    
    //MARK: - Interface
    func setRecordButtonSelectedState(state: Bool) {
        recordButton.selected = state
    }
    
    func setRecordButtonEnable(state: Bool) {
        longPressGesture?.enabled = state
        recordButton.enabled = state
    }
    
    func setLowValueLabelString(text: String) {
        lowValueLabel.text = text
    }
    
    func setActualValueLabelString(text: String) {
        actualValueLabel.text = text
    }
    
    func setHighValueLabelString(text: String) {
        highValueLabel.text = text
    }
    
    func configureRangeSlider() {
        
        self.configureUIRangeSlider()
        
        totalRecordedSlider.maximumValue = 1.0
        totalRecordedSlider.minimumValue = 0.0
        
        totalRecordedSlider.lowerHandleHidden = true
        totalRecordedSlider.upperValue = 0.0
        
        Utils.sharedInstance.debugLog("maximum value\(totalRecordedSlider.maximumValue) \n upper value\(totalRecordedSlider.upperValue)")
    }
    
    func removeView() {
        self.removeFromSuperview()
    }
    
    func showButtons(){
        acceptButton.hidden = false
        cancelButton.hidden = false
    }
    
    func updateSliderTo(value: Float) {
        totalRecordedSlider.upperValue = value
    }
    
    //MARK: - Range UI Config
    func configureUIRangeSlider(){
        
        var trackBackgroundImage = UIImage(named: "button_edit_seekbar_background_split")
        trackBackgroundImage = trackBackgroundImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 5.0, 0.0, 5.0))
        totalRecordedSlider.trackBackgroundImage = trackBackgroundImage
        
        var handleImage = UIImage(named: "button_edit_thumb_seekbar_over_advance_split")
        handleImage = handleImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageNormal = handleImage
        
        let handleImagePressed = UIImage(named: "button_edit_thumb_seekbar_advance_split_pressed")
        handleImage = handleImage?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 2, 0.0, 2))
        totalRecordedSlider.upperHandleImageHighlighted = handleImagePressed
        
    }
}