//
//  AddTextPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class AddTextPresenter{
    var interactor:AddTextInteractorInterface?
    var delegate:AddTextPresenterDelegate?
    
    var maxCharForLine = 30
    var videoSelectedIndex:Int!{
        didSet{
            interactor?.setVideoPosition(videoSelectedIndex)
        }
    }
    enum AlignmentButtonPresset {
        case Top
        case Mid
        case Bottom
    }
    
    var lastButtonPushed:AlignmentButtonPresset = .Top
    
    var isGoingToExpandPlayer = false
}

//MARK: - Presenter interface
extension AddTextPresenter:AddTextPresenterInterface{
    func viewDidLoad() {
        
        delegate?.bringToFrontExpandPlayerButton()
        
        interactor?.setUpComposition({composition in
            self.delegate?.updatePlayerOnView(composition)
        })
    }
    
    func viewWillDissappear() {
        if !isGoingToExpandPlayer{
            
            delegate?.setStopToVideo()
        }
    }
    
    func pushAcceptHandler() {
        //        interactor?.setParametersOnVideoSelectedOnProjectList(lowerValue,
        //                                                              stopTime: upperValue)
        
        delegate?.acceptFinished()
    }
    
    func pushCancelHandler() {
        delegate?.pushBackFinished()
    }
    
    func pushBack() {
        delegate?.pushBackFinished()
    }
    
    func topButtonPushed() {
        deselectLastButtonPushed()
        
        delegate?.setTextAlignment(.VerticalAlignmentTop)
        delegate?.setSelectedTopButton(true)
        
        lastButtonPushed = .Top
    }
    
    func midButtonPushed() {
        deselectLastButtonPushed()

        delegate?.setTextAlignment(.VerticalAlignmentMiddle)
        delegate?.setSelectedMidButton(true)
        
        lastButtonPushed = .Mid
    }
    
    func bottomButtonPushed() {
        deselectLastButtonPushed()

        delegate?.setTextAlignment(.VerticalAlignmentBottom)
        delegate?.setSelectedBottomButton(true)
        
        lastButtonPushed = .Bottom
    }
    
    func deselectLastButtonPushed(){
        switch lastButtonPushed {
        case .Top:
            delegate?.setSelectedTopButton(false)
        case .Mid:
            delegate?.setSelectedMidButton(false)
        case .Bottom:
            delegate?.setSelectedBottomButton(false)
        }
    }
    
    func expandPlayer() {
        isGoingToExpandPlayer = true
        
        delegate?.expandPlayerToView()
    }
    
    func textHasChanged(text: String) {
        delegate?.setTextToPlayer(addLineBreakIfNeccesary(text))
    }
}

//MARK: - Interactor delegate
extension AddTextPresenter:AddTextInteractorDelegate{
    
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