//
//  EditingRoomPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class EditingRoomPresenter: NSObject,EditingRoomPresenterInterface {
    
    //MARK: - Variables VIPER
    var controller: EditingRoomViewInterface?
    var wireframe: EditingRoomWireframe?
    var interactor:EditingRoomInteractorInterface?
    
    //MARK: Variables
    enum controllerVisible {
        case editor
        case music
        case share
    }
    
    var whatControllerIsVisible:controllerVisible?
    
    //MARK: - Event handler
    func viewDidLoad(){
        wireframe?.showEditorInContainer()
    }
    
    func viewWillDisappear() {
        whatControllerIsVisible = nil
    }
    
    func viewWillAppear() {

    }
    
    func pushBack() {
        wireframe?.goPrevController()
    }
    
    func pushMusic() {
        if whatControllerIsVisible != .music{
            whatControllerIsVisible = .music
            
            controller?.deselectAllButtons()
            controller?.selectMusicButton()
            
            wireframe?.showMusicInContainer()
        }
    }
    
    func pushShare() {
        if whatControllerIsVisible != .share{
            whatControllerIsVisible = .share
            controller?.deselectAllButtons()
            controller?.selectShareButton()
            controller?.createAlertWaitToExport()
            
            let exporter = ExporterInteractor.init(project: (interactor?.getProject())!)
            exporter.exportVideos({
                exportPath,videoTotalTime in
                print("Export path response = \(exportPath)")
                self.controller?.dissmissAlertWaitToExport({
                    
                    self.wireframe?.showShareInContainer(exportPath, numberOfClips: (self.interactor?.getNumberOfClips())!)
                })
            })
        }
    }
    
    func pushEditor() {
        if whatControllerIsVisible != .editor{
            whatControllerIsVisible = .editor
            controller?.deselectAllButtons()
            controller?.selectEditorButton()
            
            wireframe?.showEditorInContainer()
        }
    }
    
    func pushSettings() {
        wireframe?.presentSettingsInterface()
    }
}
