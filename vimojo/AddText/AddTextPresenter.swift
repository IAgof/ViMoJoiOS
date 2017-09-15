//
//  AddTextPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class AddTextPresenter {
    var interactor: AddTextInteractorInterface?
    var delegate: AddTextPresenterDelegate?

    var videoSelectedIndex: Int! {
        didSet {
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    enum AlignmentButtonPresset: Int {
        case top = 0
        case mid = 1
        case bottom = 2
    }

    var lastButtonPushed: AlignmentButtonPresset = .top

    var isGoingToExpandPlayer = false

    var textOnLabel: String = ""
}

// MARK: - Presenter interface
extension AddTextPresenter:AddTextPresenterInterface {
    func viewDidLoad() {

        delegate?.bringToFrontExpandPlayerButton()
        interactor?.setUpComposition({composition in
            self.delegate?.updatePlayerOnView(composition)
        })
        interactor?.getVideoParams()
    }

    func viewWillDissappear() {
        if !isGoingToExpandPlayer {

            delegate?.setStopToVideo()
        }
    }

    func pushAcceptHandler() {
        interactor?.setParametersToVideo(textOnLabel,
                                         position: lastButtonPushed.rawValue)

        ViMoJoTracker.sharedInstance.trackClipAddedText(position: String(lastButtonPushed.rawValue),
                                                        textLength: textOnLabel.characters.count)
        delegate?.acceptFinished()
    }

    func pushCancelHandler() {
        delegate?.pushBackFinished()
    }

    func pushBack() {
        delegate?.pushBackFinished()
    }

    func topButtonPushed() {
        deselectLastButtonPushed(lastButtonPushed)

        delegate?.setSelectedTopButton(true)

        interactor?.setAlignment(.top,
                                 text: textOnLabel)
        lastButtonPushed = .top
    }

    func midButtonPushed() {
        deselectLastButtonPushed(lastButtonPushed)

        delegate?.setSelectedMidButton(true)

        interactor?.setAlignment(.mid,
                                 text: textOnLabel)

        lastButtonPushed = .mid
    }

    func bottomButtonPushed() {
        deselectLastButtonPushed(lastButtonPushed)

        delegate?.setSelectedBottomButton(true)

        interactor?.setAlignment(.bottom,
                                 text: textOnLabel)

        lastButtonPushed = .bottom
    }

    func deselectLastButtonPushed(_ button: AlignmentButtonPresset) {
        switch button {
        case .top:
            delegate?.setSelectedTopButton(false)
        case .mid:
            delegate?.setSelectedMidButton(false)
        case .bottom:
            delegate?.setSelectedBottomButton(false)
        }
    }

    func selectButtonPushed(_ button: AlignmentButtonPresset) {
        switch button {
        case .top:
            delegate?.setSelectedTopButton(true)
        case .mid:
            delegate?.setSelectedMidButton(true)
        case .bottom:
            delegate?.setSelectedBottomButton(true)
        }
    }
    func expandPlayer() {
        isGoingToExpandPlayer = true

        delegate?.expandPlayerToView()
    }

    func textHasChanged(_ text: String) {
        textOnLabel = text

        interactor?.getLayerToPlayer(textOnLabel)
        delegate?.setTextToEditTextField(textOnLabel)
    }
}

// MARK: - Interactor delegate
extension AddTextPresenter:AddTextInteractorDelegate {
    func setVideoParams(_ text: String, position: Int) {
        textOnLabel = text

        deselectLastButtonPushed(lastButtonPushed)

        lastButtonPushed = AlignmentButtonPresset(rawValue: position)!

        selectButtonPushed(lastButtonPushed)

        interactor?.getLayerToPlayer(text)
        delegate?.setTextToEditTextField(text)
    }

    func updateVideoList() {
        interactor?.getVideoParams()
    }

    func setAVSyncLayerToPlayer(_ layer: CALayer) {
        delegate?.setSyncLayerToPlayer(layer)
    }
}
