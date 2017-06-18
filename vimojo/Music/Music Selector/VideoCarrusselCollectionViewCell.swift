//
//  VideoCarrusselCollectionViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 17/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class VideoCarrusselCollectionViewCell: UICollectionViewCell {
    static var reusableIdentifier = "VideoCarrusselCollectionViewCellReuseIdentifier"
    static var nibName = "VideoCarrusselCollectionViewCell"
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    var action: DefaultAction?
    
    override var isSelected: Bool{
        didSet{
            self.borderColor = isSelected ? configuration.mainColor : UIColor.clear
            self.borderWidth = isSelected ? 2:0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setup(with item: SelectorItem){
        self.thumbnailImageView.image = item.image
        self.timeLabel.text = item.timeRange.start.durationText.appending(" - ").appending(item.timeRange.end.durationText)
        action = item.action
    }
}
