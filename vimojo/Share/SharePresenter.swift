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
    
    var controller: ShareInterface?
    var interactor: ShareInteractorInterface?
    var playerPresenter: PlayerPresenterInterface?
    var delegate:SharePresenterDelegate?

    var wireframe: ShareWireframe?
    var playerWireframe: PlayerWireframe?
    var recordWireframe: RecordWireframe?

    var fullScreenPlayerWireframe: FullScreenPlayerWireframe?
    
    var videoPath = ""
    var numberOfClips = 0
    var isGoingToExpandPlayer = false

    //LifeCicle
    func viewDidLoad() {
        controller!.createShareInterface()
        controller?.setNavBarTitle(Utils().getStringByKeyFromShare(ShareConstants().SHARE_YOUR_VIDEO))
        
        wireframe?.presentPlayerInterface()
        
        playerPresenter?.createVideoPlayer(GetActualProjectAVCompositionUseCase.sharedInstance.getComposition((interactor?.getProject())!))
        self.getListData()
        
        controller?.bringToFrontExpandPlayerButton()
        controller?.removeSeparatorTable()
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
        fullScreenPlayerWireframe?.presentFullScreenPlayerFromViewController((controller?.getController())!,playerView: (playerWireframe?.presentedView)!)
        isGoingToExpandPlayer = true
    }
    
    func getListData (){
       let socialNetworks = interactor?.findSocialNetworks()
        
        self.setListImageData((socialNetworks?.socialNetworkImageArray)!)
        self.setListTitleData((socialNetworks?.socialNetworkTitleArray)!)
        self.setListImagePressedData((socialNetworks?.socialNetworkImagePressedArray)!)
    }
    
    func setListTitleData(titleArray:Array<String>){
        controller?.setTitleList(titleArray)
    }
    
    func setListImageData(imageArray:Array<UIImage>){
        controller?.setImageList(imageArray)
    }
    
    func setListImagePressedData(imageArray:Array<UIImage>){
        controller?.setImagePressedList(imageArray)
    }
    func pushShare(socialNetwork: String) {
        interactor?.shareVideo(socialNetwork, videoPath: videoPath)
        
        trackVideoShared(socialNetwork)
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