//
//  MuiscSelectorTableViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class MuiscSelectorTableViewCell: UITableViewCell {
    static var reusableIdentifier = "MuiscSelectorTableViewCellReuseIdentifier"
    static var nibName = "MuiscSelectorTableViewCell"
    
    @IBOutlet weak var audioUImageView: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
   
    func setup(with music: MusicSelectorCellViewModel){
        audioUImageView.image = music.icon
        for item in music.items{
            stackView.addArrangedSubview(SelectorItemView(item: item))
        }
    }
}

class SelectorItemView: UIView{
    var imageView: UIImageView = UIImageView(frame: CGRect.zero)
    var label: UILabel = UILabel(frame: CGRect.zero)
    
    init( frame: CGRect, item: SelectorItem){
        self.init(frame: frame)
        setup()
        self.imageView.image = item.image
        self.label.text = item.timeRange.start.durationText.appending(":").appending(item.timeRange.end.durationText)
    }
    
    override convenience init(frame: CGRect) {
        self.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.8)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
