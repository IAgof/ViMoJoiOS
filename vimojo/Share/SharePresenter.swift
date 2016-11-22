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

class SharePresenter:NSObject,SharePresenterInterface{
    
    var interactor: ShareInteractorInterface?
    var playerPresenter: PlayerPresenterInterface?
    var delegate:SharePresenterDelegate?

    var wireframe: ShareWireframe?
    
    var videoPath = ""
    var numberOfClips = 0
    var isGoingToExpandPlayer = false

    //LifeCicle
    func viewDidLoad() {
        delegate!.createShareInterface()
        delegate?.setNavBarTitle(Utils().getStringByKeyFromShare(ShareConstants().SHARE_YOUR_VIDEO))
        
        wireframe?.presentPlayerInterface()
        
        playerPresenter?.createVideoPlayer(videoPath)
        interactor?.findSocialNetworks()
        
        delegate?.bringToFrontExpandPlayerButton()
        delegate?.removeSeparatorTable()
    }
    
    func viewWillDisappear() {
        if !isGoingToExpandPlayer{
            playerPresenter?.onVideoStops()
        }
    }
    
    func setVideoExportedPath(_ path: String) {
        self.videoPath = path
        
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
        interactor?.shareVideo(indexPath, videoPath: videoPath)
        
        //TODO: Hacer algo con el interactor delegate para hacerle el tracking
        //        trackVideoShared(socialNetwork)
    }
    
    func postToYoutube(_ token:String){
        interactor!.postToYoutube(token)
    }

    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func pushGenericShare() {
        delegate?.showShareGeneric(videoPath)
    }
    
    //MARK: - Mixpanel Tracking
    func trackVideoShared(_ socialNetworkName: String) {
        let duration = AVAsset(url: URL(fileURLWithPath: videoPath)).duration.seconds
        
        ViMoJoTracker.sharedInstance.trackVideoShared(socialNetworkName,
                                                        videoDuration: duration,
                                                        numberOfClips: numberOfClips)
    }
}

extension SharePresenter:ShareInteractorDelegate{
    func setShareObjectsToView(_ viewObjects: [ShareViewModel]){
        delegate?.setShareViewObjectsList(viewObjects)
    }
}
