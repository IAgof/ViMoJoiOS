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
}
