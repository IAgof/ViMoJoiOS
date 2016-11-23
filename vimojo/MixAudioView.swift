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
    func mixVolumeValueChanged(_ value:Float)
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
        return UINib(nibName: "MixAudioView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func awakeFromNib() {

    }
    
    func setViewFrame(_ frame:CGRect){
        self.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
    }
    
    //MARK: - Actions
    @IBAction func acceptButtonPushed(_ sender: AnyObject) {
        delegate?.mixAudioAcceptButtonPushed()
    }
    
    @IBAction func cancelButtonPushed(_ sender: AnyObject) {
        delegate?.mixAudioCancelButtonPushed()
    }
    
    @IBAction func mixAudioValueChanged(_ sender: AnyObject) {
        sliderValueLabel.text = "\(Int(mixAudioSlider.value * 100))%"
        delegate?.mixVolumeValueChanged(mixAudioSlider.value)
    }
    
    //MARK: - Interface
    func removeView() {
        self.removeFromSuperview()
    }
}
