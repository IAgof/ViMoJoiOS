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

    let cellColor = configuration.mainColor

    override func awakeFromNib() {
        positionNumberLabel.adjustsFontSizeToFitWidth = true
        removeClipButton.isHidden = true
        thumbnailImageView.image = #imageLiteral(resourceName: "video_removed")
    }

    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = (isSelected ? 3 : 0)
            self.layer.borderColor = (isSelected ? cellColor.cgColor : UIColor.clear.cgColor)

            self.removeClipButton.backgroundColor = (isSelected ? cellColor : UIColor.clear)

            removeClipButton.isHidden = !isSelected
            removeClipButton.isEnabled = isSelected
        }
    }

    var isMoving = false {
        didSet {
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(rotationAngle: self.isMoving ? CGFloat(Double.pi / 4) : CGFloat(0))
            })
        }
    }

}
