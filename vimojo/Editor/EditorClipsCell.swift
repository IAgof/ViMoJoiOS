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
    @IBOutlet weak var removeClipButton: UIButton!
    
    let cellColor = VIMOJO_GREEN_UICOLOR
    
    override func awakeFromNib() {
        positionNumberLabel.adjustsFontSizeToFitWidth = true
        removeClipButton.hidden = true
    }
    
    var isClipSelected: Bool = false{
        didSet {            
            self.layer.borderWidth = (isClipSelected ? 3 : 0)
            self.layer.borderColor = (isClipSelected ? cellColor.CGColor : UIColor.clearColor().CGColor)
            
            self.removeClipButton.backgroundColor = (isClipSelected ? cellColor : UIColor.clearColor())
            
            removeClipButton.hidden = !isClipSelected
        }
    }
    
    var isMoving = false{
        didSet{
            UIView.animateWithDuration(0.25, animations:{
                self.transform = CGAffineTransformMakeRotation(self.isMoving ? CGFloat(M_PI_4) : CGFloat(0))
            })
        }
    }
    
}
