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
import VideonaProject
import VideonaProject
import Photos

class SharePresenter: NSObject, SharePresenterInterface {

    var interactor: ShareInteractorInterface?
    var playerPresenter: PlayerPresenterInterface?
    var delegate: SharePresenterDelegate?

    var wireframe: ShareWireframe?

    var videoURL: URL?

    var numberOfClips = 0
    var isGoingToExpandPlayer = false

    //LifeCicle
    func viewDidLoad() {
        delegate!.createShareInterface()
        playerPresenter?.removePlayer()

        interactor?.findSocialNetworks()
        delegate?.removeSeparatorTable()
    }

    func updatePlayerView() {
        DispatchQueue.main.async {
            self.wireframe?.presentPlayerInterface()
            self.delegate?.bringToFrontExpandPlayerButton()
        }
    }

    func viewDidAppear() {
		delegate?.createAlertWaitToExport {
			self.delegate?.dissmissAlertWaitToExport()
			self.interactor?.cancelExport()
			self.wireframe?.presentEditor()
		}

        interactor?.exportVideo()
    }
    
    func getSessionExportProgress(_ progressUpdate: @escaping (Int) -> Void ) {
        self.interactor?.getExportedElapsedSessionTime({
            progress in
            progressUpdate(progress)
        })
    }

    func viewWillDisappear() {
        if !isGoingToExpandPlayer {
            playerPresenter?.onVideoStops()
        }
        delegate?.dissmissAlertWaitToExport()
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

    func expandPlayer() {
        wireframe?.presentExpandPlayer()
        isGoingToExpandPlayer = true
    }

    func pushShare(_ indexPath: IndexPath) {
        if let path = videoURL?.absoluteString {
            interactor?.shareVideo(indexPath, videoPath: path)
        }
    }

    func postToYoutube(_ token: String) {
        interactor!.postToYoutube(token)
    }

    func pushOptions() {
        wireframe?.presentSettings()
    }

    func updatePlayerLayer() {
        playerPresenter!.layoutSubViews()
    }

    func pushGenericShare() {
        if let videoURL = interactor?.getShareExportURL() {
            self.delegate?.showShareGeneric(videoURL)
        }
    }

    func exportFailOkPushed() {
        wireframe?.presentEditor()
    }
}

extension SharePresenter:ShareInteractorDelegate {
    func setShareObjectsToView(_ viewObjects: [ShareViewModel]) {
        delegate?.setShareViewObjectsList(viewObjects)
    }

    func setPlayerUrl(videoURL: URL) {
        updatePlayerView()

        self.videoURL = videoURL

        playerPresenter?.createVideoPlayer(videoURL)
    }

    func exportFinished(withError: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.delegate?.dissmissAlertWaitToExport()

            if withError {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.delegate?.createAlertExportFailed()
                }
            }
        }
    }

}
