//
//  MuiscSelectorTableViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class MuiscSelectorTableViewCell: UITableViewCell {
    static var reusableIdentifier = "MuiscSelectorTableViewCellReuseIdentifier"
    static var nibName = "MuiscSelectorTableViewCell"
    
    @IBOutlet weak var audioUImageView: UIImageView!
   
    func setup(with music: MusicSelectorCellViewModel){
        audioUImageView.image = music.icon
    }
}
