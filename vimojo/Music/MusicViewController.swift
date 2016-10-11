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

class MusicViewController: ViMoJoController,MusicViewInterface,MusicPresenterDelegate,PlayerViewSetter,FullScreenWireframeDelegate{
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
    var micRecorderView:MicRecorderViewInterface?
    
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
    
    @IBAction func pushMusic(sender: AnyObject) {
        eventHandler?.pushMusicHandler()
    }
    
    @IBAction func pushMic(sender: AnyObject) {
        eventHandler?.pushMicHandler()
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
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}