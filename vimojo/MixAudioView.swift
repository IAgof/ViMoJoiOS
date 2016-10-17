//
//  MixAudioView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import NMRangeSlider

protocol MixAudioViewDelegate {
    func mixAudioAcceptButtonPushed()
    func mixAudioCancelButtonPushed()
    func mixVolumeValueChanged(value:Float)
}

protocol MixAudioViewInterface {
    func removeView()
}

class MixAudioView: UIView,MixAudioViewInterface{
    
    //MARK: - Outlets
    @IBOutlet weak var sliderValueLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var mixAudioSlider: UISlider!
    
    //MARK: - Variables
    var delegate:MixAudioViewDelegate?
    
    //MARK: - Init
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MixAudioView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {

    }
    
    func setViewFrame(frame:CGRect){
        self.frame = CGRectMake(0, 0, frame.width, frame.height)
    }
    
    //MARK: - Actions
    @IBAction func acceptButtonPushed(sender: AnyObject) {
        delegate?.mixAudioAcceptButtonPushed()
    }
    
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        delegate?.mixAudioCancelButtonPushed()
    }
    
    @IBAction func mixAudioValueChanged(sender: AnyObject) {
        sliderValueLabel.text = "\(Int(mixAudioSlider.value * 100))%"
        delegate?.mixVolumeValueChanged(mixAudioSlider.value)
    }
    
    //MARK: - Interface
    func removeView() {
        self.removeFromSuperview()
    }
}