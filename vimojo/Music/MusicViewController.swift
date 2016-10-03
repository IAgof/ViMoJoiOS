//
//  MusicViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 27/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaPlayer

class MusicViewController: ViMoJoController,MusicViewInterface,MusicPresenterDelegate,MusicDetailViewDelegate,PlayerViewSetter,
UITableViewDataSource,UITableViewDelegate,FullScreenWireframeDelegate{
    //MARK: - VIPER variables
    var eventHandler: MusicPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicTableView: UITableView!
    @IBOutlet weak var musicContainer: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - Variables and constants
    let cellIdentifier = "musicCell"
    
    var musicViewModelList:[MusicViewModel] = []{
        didSet{
            musicTableView.reloadData()
        }
    }
    
    var detailMusicView:MusicDetailView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.viewWillAppear()
    }
    
    override func viewDidAppear(animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: Actions
    @IBAction func pushExpandButton(sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    //MARK: Interface
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubviewToFront(expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
    
    //MARK: - Tableview delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        eventHandler?.didSelectMusicAtIndexPath(indexPath)
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
    
    //MARK: - Presenter delegate
    func setMusicList(list: [MusicViewModel]) {
        self.musicViewModelList = list
    }
    
    //MARK: - Music Detail Delegate
    func acceptButtonPushed() {
        eventHandler?.acceptDetailButtonPushed()
    }
    func cancelButtonPushed() {
        eventHandler?.cancelDetailButtonPushed()
    }
    func removeDetailButtonPushed() {
        eventHandler?.removeDetailButtonPushed()
    }
    
    //MARK: - Change views
    func removeTableFromView() {
        musicTableView.hidden = true
    }
    
    func setTableToView() {
        musicTableView.hidden = false
    }
    
    func removeDetailFromView() {
        detailMusicView?.removeFromSuperview()
    }
    
    func animateToShowTable(){
        UIView.animateWithDuration(0.5, animations: {
            self.musicTableView.alpha = 1
            self.detailMusicView!.alpha = 0.2
            },
                                   completion: { finished in
                                    self.setTableToView()
                                    self.removeDetailFromView()
        })
    }
    
    func animateToShowDetail(title:String,
                             author:String,
                             image:UIImage) {
        self.setUpDetailView(title, author: author, image: image)
        
        UIView.animateWithDuration(0.3, animations: {
            self.detailMusicView!.alpha = 1
            self.musicTableView.alpha = 0.2
            },
                                   completion: { finished in
                                    self.setDetailToView()
                                    self.removeTableFromView()
        })
    }
    
    func setDetailToView() {
        musicContainer.addSubview(detailMusicView!)
    }
    
    func setUpDetailView(title:String,
                         author:String,
                         image:UIImage){
        
        let view = MusicDetailView.instanceFromNib()
        
        detailMusicView = view as? MusicDetailView
                
        eventHandler?.setMusicDetailInterface(detailMusicView!)

        detailMusicView?.delegate = self
        
        detailMusicView?.initParams(title,
                                    author: author,
                                    image: image,
                                    frame: musicContainer.frame)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

