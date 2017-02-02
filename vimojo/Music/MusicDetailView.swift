//
//  MusicDetailView.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol MusicDetailViewDelegate {
    func cancelButtonPushed()
    func acceptButtonPushed()
    func removeDetailButtonPushed()
    func mixAudioChanged(withValue value:Float)
}
protocol MusicDetailInterface {
    func showAcceptOrCancelButton()
    func showRemoveButton()
}

class MusicDetailView: UIView,MusicDetailInterface {
    
    //MARK: - Outlets
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var mixMusicAudioSlider: UISlider!
    @IBOutlet weak var sliderContainerView: UIView!
    @IBOutlet weak var durationLabel: UILabel!
    
    //MARK: - Variables
    var delegate:MusicDetailViewDelegate?
    
    //MARK: - Init
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MusicDetailView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func initParams(musicDetailViewModel detail: MusicDetailViewModel,
         frame:CGRect) {
        
        musicImage.image = detail.image
        titleLabel.text = detail.title
        authorLabel.text = detail.author
        durationLabel.text = detail.duration
        
        titleLabel.adjustsFontSizeToFitWidth = true
        authorLabel.adjustsFontSizeToFitWidth = true
        
        let offset = CGFloat(10)
        self.frame = CGRect(x: (offset/2), y: 0, width: (frame.width - offset), height: (frame.height - offset) )
        
        self.mixMusicAudioSlider.value = detail.sliderValue
        self.applyPlainShadow()
        
        if configuration.VOICE_OVER_FEATURE {
            self.sliderContainerView.isHidden = true
        }
    }
    
    func applyPlainShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 10)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    //MARK: - Actions
    @IBAction func pushCancelButton(_ sender: AnyObject) {
        delegate?.cancelButtonPushed()
    }
    
    @IBAction func pushAcceptButton(_ sender: AnyObject) {
        delegate?.acceptButtonPushed()
    }
    @IBAction func pushRemoveButton(_ sender: AnyObject) {
        delegate?.removeDetailButtonPushed()
    }
    
    @IBAction func mixMusixAudioSliderChanged(_ sender: Any) {
        delegate?.mixAudioChanged(withValue: mixMusicAudioSlider.value)
    }
    
    //MARK: - Show Actions
    func showAcceptOrCancelButton(){
        acceptButton.isHidden = false
        cancelButton.isHidden = false
        
        removeButton.isHidden = true
    }
    
    func showRemoveButton(){
        acceptButton.isHidden = true
        cancelButton.isHidden = true
        
        removeButton.isHidden = false
    }
}
