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

class MusicViewController: ViMoJoController,MusicViewInterface,MusicPresenterDelegate,MusicDetailViewDelegate,PlayerViewSetter,FullScreenWireframeDelegate{
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
    
    //MARK: - Presenter delegate
    func setMusicList(list: [MusicViewModel]) {
        self.musicListView?.musicViewModelList = list
    }
    
    func showDetailView(title:String,
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
    
    func showMicRecordView(micRecorderViewModel: MicRecorderViewModel) {
        let view = MicRecorderView.instanceFromNib() as? MicRecorderView
        micRecorderView = view
        view?.delegate = self
        
        musicContainer.addSubview(view!)
        view?.setViewFrame(musicContainer.frame)
        
        micRecorderView?.setLowValueLabelString(micRecorderViewModel.lowValue)
        micRecorderView?.setHighValueLabelString(micRecorderViewModel.highValue)
        micRecorderView?.setActualValueLabelString(micRecorderViewModel.actualValue)
        micRecorderView?.configureRangeSlider()
    }
    
    func hideMicRecordView() {
        micRecorderView?.removeView()
    }
    
    func showMicRecorderAcceptCancelButton() {
        micRecorderView?.showButtons()
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
    func removeDetailFromView() {
        detailMusicView?.removeFromSuperview()
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
        
        musicContainer.addSubview(detailMusicView!)
    }
    
    func setMicRecorderButtonState(state: Bool) {
        micRecorderView?.setRecordButtonSelectedState(state)
    }
    
    func setMicRecorderButtonEnabled(state: Bool) {
        micRecorderView?.setRecordButtonEnable(state)
    }
    
    //MARK: - Player setter
    func addPlayerAsSubview(player: PlayerView) {
        self.playerView.addSubview(player)
    }
}

extension MusicViewController:MusicListViewDelegate{
    func didSelectMusicAtIndexPath(indexPath:NSIndexPath){
        eventHandler?.didSelectMusicAtIndexPath(indexPath)
    }
    
    func cancelMusicListButtonPushed(){
        self.hideTableView()
    }
}

extension MusicViewController:MicRecorderViewDelegate{
    func micRecorderLongPressStart(){
        eventHandler?.startLongPress()
    }
    
    func micRecorderLongPressFinished(){
        eventHandler?.pauseLongPress()
    }
    
    func micRecorderAcceptButtonPushed(){
        eventHandler?.acceptMicRecord()
    }
    
    func micRecorderCancelButtonPushed(){
        eventHandler?.cancelMicRecord()
    }
    
    func updateRecordMicActualTime(time: String) {
        micRecorderView?.setActualValueLabelString(time)
    }
}

extension MusicViewController:PlayerViewDelegate{
    func seekBarUpdate(value: Float) {
        micRecorderView?.updateSliderTo(value)
        eventHandler?.updateActualTime(value)
    }
}