//
//  SharePresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import VideonaPlayer
import VideonaProject
import Photos

class SharePresenter:NSObject,SharePresenterInterface{
    
    var interactor: ShareInteractorInterface?
    var playerPresenter: PlayerPresenterInterface?
    var delegate:SharePresenterDelegate?
    
    var wireframe: ShareWireframe?
    
    var videoURL:URL?
    
    var numberOfClips = 0
    var isGoingToExpandPlayer = false
    
    //LifeCicle
    func viewDidLoad() {
        delegate!.createShareInterface()
        delegate?.setNavBarTitle(Utils().getStringByKeyFromShare(ShareConstants().SHARE_YOUR_VIDEO))
        
        interactor?.findSocialNetworks()
        delegate?.removeSeparatorTable()
    }
    
    func updatePlayerView(){
        DispatchQueue.main.async {
            self.wireframe?.presentPlayerInterface()
            self.delegate?.bringToFrontExpandPlayerButton()
        }
    }
    
    func viewDidAppear() {
        updatePlayerView()

        delegate?.createAlertWaitToExport()
        
        interactor?.exportVideo()
    }
    
    func viewWillDisappear() {
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
    }
    
    func setVideoExportedPath(_ url: URL) {
        self.videoURL = url
    }
    
    func setNumberOfClipsToExport(_ numberOfClips: Int) {
        self.numberOfClips = numberOfClips
    }
    
    func pushBack() {
        DispatchQueue.global().async {
            self.playerPresenter?.pauseVideo()
        }
        wireframe?.goPrevController()
    }
    
    func expandPlayer(){
        wireframe?.presentExpandPlayer()
        isGoingToExpandPlayer = true
    }
    
    func pushShare(_ indexPath:IndexPath){
        if let path = videoURL?.absoluteString{
            interactor?.shareVideo(indexPath, videoPath: path)
        }
        
        //TODO: Hacer algo con el interactor delegate para hacerle el tracking
        //        trackVideoShared(socialNetwork)
    }
    
    func postToYoutube(_ token:String){
        interactor!.postToYoutube(token)
    }
    
    func pushOptions() {
        wireframe?.presentSettings()
    }
    
    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func pushGenericShare() {
        if let videoURL = interactor?.getShareExportURL(){
            self.delegate?.showShareGeneric(videoURL)
        }
    }
    
    //MARK: - Mixpanel Tracking
    func trackVideoShared(_ socialNetworkName: String) {
        if let url = videoURL{
            let duration = AVAsset(url: url).duration.seconds
            
            ViMoJoTracker.sharedInstance.trackVideoShared(socialNetworkName,
                                                          videoDuration: duration,
                                                          numberOfClips: numberOfClips)
        }
        
    }
}

extension SharePresenter:ShareInteractorDelegate{
    func setShareObjectsToView(_ viewObjects: [ShareViewModel]){
        delegate?.setShareViewObjectsList(viewObjects)
    }
    
    func setPlayerUrl(videoURL: URL) {
        delegate?.dissmissAlertWaitToExport()
        
        self.videoURL = videoURL
        
        playerPresenter?.createVideoPlayer(videoURL)
    }
}
