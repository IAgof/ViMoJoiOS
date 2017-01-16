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

class MusicViewController: EditingRoomItemController,MusicViewInterface,MusicPresenterDelegate,PlayerViewSetter,FullScreenWireframeDelegate{
    //MARK: - VIPER variables
    var eventHandler: MusicPresenterInterface?
    
    //MARK: - Outlet
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var musicContainer: UIView!
    @IBOutlet weak var expandPlayerButton: UIButton!

    //MARK: - Variables and constants
    let cellIdentifier = "musicCell"
    
    var detailMusicView:MusicDetailView?
    var musicListView:MusicListView?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler?.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventHandler?.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        eventHandler?.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        eventHandler?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    //MARK: Actions
    @IBAction func pushExpandButton(_ sender: AnyObject) {
        eventHandler?.expandPlayer()
    }
    
    @IBAction func pushMusic(_ sender: AnyObject) {
        eventHandler?.pushMusicHandler()
    }
    
    @IBAction func pushMic(_ sender: AnyObject) {
        eventHandler?.pushMicHandler()
    }
    
    @IBAction func pushOptionsButton(_ sender: Any) {
        eventHandler?.pushOptions()
    }
    
    //MARK: Interface
    func bringToFrontExpandPlayerButton(){
        self.playerView.bringSubview(toFront: expandPlayerButton)
    }
    
    func cameFromFullScreenPlayer(_ playerView:PlayerView){
        self.playerView.addSubview(playerView)
        self.playerView.bringSubview(toFront: expandPlayerButton)
        eventHandler?.updatePlayerLayer()
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(_ player: PlayerView) {
        self.playerView.addSubview(player)
    }
}
