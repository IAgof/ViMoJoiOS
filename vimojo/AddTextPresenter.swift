//
//  AddTextPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaPlayer
import AVFoundation

class AddTextPresenter{
    var interactor:AddTextInteractorInterface?
    var delegate:AddTextPresenterDelegate?
    
    var maxCharForLine = 30
    var videoSelectedIndex:Int!{
        didSet{
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    enum AlignmentButtonPresset:Int {
        case Top = 0
        case Mid = 1
        case Bottom = 2
    }
    
    var lastButtonPushed:AlignmentButtonPresset = .Top
    
    var isGoingToExpandPlayer = false
    
    var textOnLabel:String = ""
}

//MARK: - Presenter interface
extension AddTextPresenter:AddTextPresenterInterface{
    func viewDidLoad() {
        
        delegate?.bringToFrontExpandPlayerButton()
        interactor?.setUpComposition({composition in
            self.delegate?.updatePlayerOnView(composition)
        })
        interactor?.getVideoParams()
    }
    
    func viewWillDissappear() {
        if !isGoingToExpandPlayer{
            
            delegate?.setStopToVideo()
        }
    }
    
    func pushAcceptHandler() {
        interactor?.setParametersToVideo(textOnLabel,
                                         position: lastButtonPushed.rawValue)

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
        lastButtonPushed = .Top
    }
    
    func midButtonPushed() {
        deselectLastButtonPushed(lastButtonPushed)

        delegate?.setSelectedMidButton(true)
        
        interactor?.setAlignment(.mid,
                                 text: textOnLabel)
        
        lastButtonPushed = .Mid
    }
    
    func bottomButtonPushed() {
        deselectLastButtonPushed(lastButtonPushed)

        delegate?.setSelectedBottomButton(true)
        
        interactor?.setAlignment(.bottom,
                                 text: textOnLabel)
        
        lastButtonPushed = .Bottom
    }
    
    func deselectLastButtonPushed(button:AlignmentButtonPresset){
        switch button {
        case .Top:
            delegate?.setSelectedTopButton(false)
        case .Mid:
            delegate?.setSelectedMidButton(false)
        case .Bottom:
            delegate?.setSelectedBottomButton(false)
        }
    }
    
    func selectButtonPushed(button:AlignmentButtonPresset){
        switch button {
        case .Top:
            delegate?.setSelectedTopButton(true)
        case .Mid:
            delegate?.setSelectedMidButton(true)
        case .Bottom:
            delegate?.setSelectedBottomButton(true)
        }
    }
    func expandPlayer() {
        isGoingToExpandPlayer = true
        
        delegate?.expandPlayerToView()
    }
    
    func textHasChanged(text: String) {
        textOnLabel = addLineBreakIfNeccesary(text)

        interactor?.getTextImage(text)
    }
}

//MARK: - Interactor delegate
extension AddTextPresenter:AddTextInteractorDelegate{
    func setVideoParams(text: String, position: Int) {
        textOnLabel = text
        
        deselectLastButtonPushed(lastButtonPushed)
        
        lastButtonPushed = AlignmentButtonPresset(rawValue: position)!
        
        selectButtonPushed(lastButtonPushed)
        
        interactor?.getTextImage(text)
        delegate?.setTextToEditTextField(text)
    }
    
    func updateVideoList() {
        interactor?.getVideoParams()
    }
        
    func setAVSyncLayerToPlayer(layer: CALayer) {
        delegate?.setSyncLayerToPlayer(layer)
    }
}

//MARK: - Inner functions
extension AddTextPresenter{
    func addLineBreakIfNeccesary(text:String)->String{
        if text.characters.count > maxCharForLine {
            let nextLine = "\n"

            let preText = text.substringWithRange(Range<String.Index>(start: text.startIndex, end: text.startIndex.advancedBy(maxCharForLine)))
            let postText = text.substringWithRange(Range<String.Index>(start: text.startIndex.advancedBy(maxCharForLine), end: text.endIndex))
            
            let finalText = preText + nextLine + postText
            
            return finalText
        }
        return text
    }
}