//
//  MusicListController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 11/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

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
        
        if configuration.VOICE_OVER_FEATURE{
            configureNavigationBarWithBackButton()
        }else{
            configureNavigationBarWithDrawerAndOptions()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func pushOptions(){
        eventHandler?.pushOptions()
    }
    
    override func pushBack(){
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
    
    func showDetailView(musicDetailViewModel detail: MusicDetailViewModel){
        self.setUpDetailView(musicDetailViewModel: detail)
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
    
    func setUpDetailView(musicDetailViewModel detail: MusicDetailViewModel){
        
        let view = MusicDetailView.instanceFromNib()
        
        detailMusicView = view as? MusicDetailView
        
        eventHandler?.setMusicDetailInterface(detailMusicView!)
        
        detailMusicView?.delegate = self
        
        detailMusicView?.initParams(musicDetailViewModel: detail, frame: musicContainer.frame)
        
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
    
    func mixAudioChanged(withValue value: Float) {
        eventHandler?.setMixAudioValue(mixAudioValue: value)
    }
}

extension MusicListViewController:PlayerViewSetter{
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension MusicListViewController:PlayerViewFinishedDelegate{
    func playerHasLoaded(){
        eventHandler?.playerHasLoaded()
    }
    func playerStartsToPlay(){
        
    }
    func playerPause(){
        
    }
    func playerSeeksTo(_ value:Float){
        
    }
}
