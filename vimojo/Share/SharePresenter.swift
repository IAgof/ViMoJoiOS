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
    
    func setVideoExportedPath(path: String) {
        self.videoPath = path
        
    }
    
    func setNumberOfClipsToExport(numberOfClips: Int) {
        self.numberOfClips = numberOfClips
    }
    
    func pushBack() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.playerPresenter?.pauseVideo()
        }
        
        wireframe?.goPrevController()
    }
    
    func expandPlayer(){
        wireframe?.presentExpandPlayer()
        isGoingToExpandPlayer = true
    }
    
    func pushShare(indexPath:NSIndexPath){
        interactor?.shareVideo(indexPath, videoPath: videoPath)
        
        //TODO: Hacer algo con el interactor delegate para hacerle el tracking
        //        trackVideoShared(socialNetwork)
    }
    
    func postToYoutube(token:String){
        interactor!.postToYoutube(token)
    }

    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }
    
    func pushGenericShare() {
        delegate?.showShareGeneric(videoPath)
    }
    
    //MARK: - Mixpanel Tracking
    func trackVideoShared(socialNetworkName: String) {
        let duration = AVAsset(URL: NSURL(fileURLWithPath: videoPath)).duration.seconds
        
        ViMoJoTracker.sharedInstance.trackVideoShared(socialNetworkName,
                                                        videoDuration: duration,
                                                        numberOfClips: numberOfClips)
    }
}

extension SharePresenter:ShareInteractorDelegate{
    func setShareObjectsToView(viewObjects: [ShareViewModel]){
        delegate?.setShareViewObjectsList(viewObjects)
    }
}