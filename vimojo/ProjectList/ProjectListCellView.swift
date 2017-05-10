//
//  ProjectListCellView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

class ProjectListViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var duplicateProjectButton: UIButton!
    @IBOutlet weak var removeProjectButton: UIButton!
    @IBOutlet weak var editProjectButton: UIButton!
    @IBOutlet weak var shareProjectButton: UIButton!

    override func awakeFromNib() {
        titleLabel.adjustsFontSizeToFitWidth = true
        durationLabel.adjustsFontSizeToFitWidth = true
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setup(with item: ProjectListViewModel, itemNumber: Int){
        self.titleLabel.text = item.title
        self.dateLabel.text = item.date
        self.durationLabel.text = item.duration
        
        DispatchQueue.main.async {
            self.thumbnailImageView.image = item.getVideoThumbnail()
        }
        
        self.editProjectButton.tag = itemNumber
        self.removeProjectButton.tag = itemNumber
        self.shareProjectButton.tag = itemNumber
        self.duplicateProjectButton.tag = itemNumber
    }
}
