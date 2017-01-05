//
//  EditorClipsCell.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 21/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

class EditorClipsCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var positionNumberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var removeClipButton: UIButton!
    
    let cellColor = mainColor
    
    override func awakeFromNib() {
        positionNumberLabel.adjustsFontSizeToFitWidth = true
        removeClipButton.isHidden = true
    }
    
    var isClipSelected: Bool = false{
        didSet {            
            self.layer.borderWidth = (isClipSelected ? 3 : 0)
            self.layer.borderColor = (isClipSelected ? cellColor.cgColor : UIColor.clear.cgColor)
            
            self.removeClipButton.backgroundColor = (isClipSelected ? cellColor : UIColor.clear)
            
            removeClipButton.isHidden = !isClipSelected
            removeClipButton.isEnabled = isClipSelected
        }
    }
    
    var isMoving = false{
        didSet{
            UIView.animate(withDuration: 0.25, animations:{
                self.transform = CGAffineTransform(rotationAngle: self.isMoving ? CGFloat(M_PI_4) : CGFloat(0))
            })
        }
    }
    
}
