//
//  MusicListView.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol MusicListViewDelegate {
    func didSelectMusicAtIndexPath(indexPath:NSIndexPath)
}

protocol MusicListViewInterface {
    var musicViewModelList:[MusicViewModel]{get set}
}

class MusicListView: UIView,MusicListViewInterface,
UITableViewDelegate,UITableViewDataSource{
    
    //MARK: - Outlets
    @IBOutlet weak var musicTableView: UITableView!
    
    //MARK: - Variables
    var delegate:MusicListViewDelegate?
    var musicViewModelList:[MusicViewModel] = []{
        didSet{
            musicTableView.reloadData()
        }
    }
    let cellIdentifier = "musicCell"

    //MARK: - Init
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "MusicListView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func registerCell(){
        let nib = UINib(nibName: "MusicListCell", bundle: nil)
        musicTableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func awakeFromNib() {
        registerCell()
    }
    
    func setViewFrame(frame:CGRect){
        self.frame = CGRectMake(0, 0, frame.width, frame.height)
    }
    
    //MARK: - Tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectMusicAtIndexPath(indexPath)
    }
    
    //MARK: - Tableview dataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicViewModelList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! MusicCell
        if musicViewModelList.indices.contains(indexPath.item) && !musicViewModelList.isEmpty{
            let music = musicViewModelList[indexPath.item]
            
            cell.musicImage.image = music.image
            cell.titleLabel.text = music.title
            cell.authorLabel.text = music.author
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if musicViewModelList.indices.contains(indexPath.item) {
            return musicViewModelList[indexPath.row].image.size.height
        }else{
            return 80
        }
    }
}