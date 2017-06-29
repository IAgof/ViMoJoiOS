//
//  MuiscSelectorTableViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit
import AVFoundation

class MuiscSelectorTableViewCell: UITableViewCell {
    static var reusableIdentifier = "MuiscSelectorTableViewCellReuseIdentifier"
    static var nibName = "MuiscSelectorTableViewCell"
    
    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var collectioView: UICollectionView!
    @IBOutlet weak var audioSlider: UISlider!
    public var tap: DefaultAction?
    private var isLoaded: Bool = false
    var sliderIsHidden: Bool = true
    var music: MusicSelectorCellViewModel?
    
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
        self.music = music
        audioButton.setImage(music.iconExpand, for: .normal)
        audioButton.setImage(music.iconShrink, for: .selected)
        self.audioButton.isSelected = !self.sliderIsHidden
        self.audioSlider.isHidden = self.sliderIsHidden
        
        self.items = music.items
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        sliderIsHidden = !sliderIsHidden
        tap?()
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        music?.audioVolume = sender.value
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


