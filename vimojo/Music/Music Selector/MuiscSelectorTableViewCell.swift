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
    @IBOutlet weak var collectioView: UICollectionView!
    fileprivate var items: [SelectorItem] = []{
        didSet{
            DispatchQueue.main.async { self.collectioView.reloadData() }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectioView.register(UINib(nibName: VideoCarrusselCollectionViewCell.nibName,bundle: nil),
                               forCellWithReuseIdentifier: VideoCarrusselCollectionViewCell.reusableIdentifier)
        collectioView.dataSource = self
        collectioView.delegate = self
    }
    func setup(with music: MusicSelectorCellViewModel){
        audioUImageView.image = music.icon
        self.items = music.items
    }
}

extension MuiscSelectorTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectioView.dequeueReusableCell(withReuseIdentifier: VideoCarrusselCollectionViewCell.reusableIdentifier, for: indexPath) as? VideoCarrusselCollectionViewCell else{ return UICollectionViewCell() }
        
        cell.setup(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectioView.cellForItem(at: indexPath) as? VideoCarrusselCollectionViewCell else { return }
        cell.action?()
    }
}


