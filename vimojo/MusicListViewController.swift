//
//  MusicListController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer

class MusicListViewController:EditingRoomItemController{
    var eventHandler: MusicListPresenterInterface?
    
    var detailMusicView:MusicDetailView?
    var musicListView:MusicListView?
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.viewWillAppear()
    }
    
    func configureDefaultNavigationBar(){
        for view in self.view.subviews{
            if let navBar = view as? UINavigationBar{
                let backIcon = #imageLiteral(resourceName: "activity_edit_back")
                
                let backItem = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(self.pushBack))
                navBar.items?[0].leftBarButtonItem = backItem
            }
        }
    }
    
    func configureNavigationBarWithDrawerAndOptions(){
        for view in self.view.subviews{
            if let navBar = view as? UINavigationBar{
                let sideSliderIcon = #imageLiteral(resourceName: "activity_edit_drawer")
                let optionsIcon = #imageLiteral(resourceName: "activity_edit_options")
                
                let showSideSliderItem = UIBarButtonItem(image: sideSliderIcon, style: .plain, target: self, action: #selector(self.showSideDrawer(_:)))
                let optionsItem = UIBarButtonItem(image: optionsIcon, style: .plain, target: self, action: #selector(self.pushOptions))
                
                navBar.items?[0].leftBarButtonItem = showSideSliderItem
                navBar.items?[0].rightBarButtonItem = optionsItem
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    func pushOptions(){
        eventHandler?.pushOptions()
    }
    
    func pushBack(){
        eventHandler?.pushBackButton()
    }
    
    //MARK: Interface
    func bringToFrontExpandPlayerButton(){
        //        self.playerView.bringSubviewToFront(expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(_ playerView:PlayerView){
        self.playerView.addSubview(playerView)
        //        self.playerView.bringSubviewToFront(expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
}

extension MusicListViewController:MusicListPresenterDelegate{
    //MARK: - Presenter delegate
    func setMusicList(_ list: [MusicViewModel]) {
        self.musicListView?.musicViewModelList = list
    }
    
    func showDetailView(_ title:String,
                        author:String,
                        image:UIImage){
        self.setUpDetailView(title, author: author, image: image)
    }
    
    func hideDetailView(){
        detailMusicView?.removeFromSuperview()
    }
    
    func showTableView() {
        let view = MusicListView.instanceFromNib()
        musicListView = view as? MusicListView
        musicListView?.delegate = self
        
        musicContainer.addSubview(musicListView!)
        musicListView?.setViewFrame(musicContainer.frame)
        
        eventHandler?.getMusicList()
    }
    
    func hideTableView() {
        musicListView?.removeFromSuperview()
    }
    
    func setUpDetailView(_ title:String,
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
        
        musicContainer.addSubview(detailMusicView!)
    }
}

extension MusicListViewController:MusicListViewDelegate{
    func didSelectMusicAtIndexPath(_ indexPath:IndexPath){
        eventHandler?.didSelectMusicAtIndexPath(indexPath)
    }
}

extension MusicListViewController:MusicDetailViewDelegate{
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
}

extension MusicListViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
