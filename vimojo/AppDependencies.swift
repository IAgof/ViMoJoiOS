//
//  AppDependencies.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import VideonaTrim
import VideonaSplit
import VideonaDuplicate
import VideonaProject
import VideonaPlayer


class AppDependencies {
    var project = Project()
    
    var recordWireframe = RecordWireframe()
    var editorRoomWireframe = EditingRoomWireframe()
    var editorWireframe = EditorWireframe()

    var playerWireframe = PlayerWireframe()
    var fullScreenPlayerWireframe = FullScreenPlayerWireframe()

    var trimWireframe = TrimWireframe()
    var duplicateWireframe = DuplicateWireframe()
    var splitWireframe = SplitWireframe()
    
    var musicWireframe = MusicWireframe()
    var shareWireframe = ShareWireframe()
    
    var settingsWireframe = SettingsWireframe()
    var detailTextWireframe = DetailTextWireframe()

    init(){
        configureDependencies()
    }

    func configureDependencies(){
        let rootWireframe = RootWireframe()
        
        let recordPresenter = RecordPresenter()
        let recordInteractor = RecorderInteractor()
        
        let playerPresenter = PlayerPresenter()
        let playerInteractor = PlayerInteractor()
        
        let fullScreenPlayerPresenter = FullScreenPlayerPresenter()
        
        let musicPresenter = MusicPresenter()
        let musicInteractor = MusicInteractor()
        
        let sharePresenter = SharePresenter()
        let shareInteractor = ShareInteractor()
        
        let editorRoomPresenter = EditingRoomPresenter()
        let editingRoomInteractor = EditingRoomInteractor(project: project)
        
        let editorPresenter = EditorPresenter()
        let editorInteractor = EditorInteractor()
        
        let trimPresenter = TrimPresenter()
        let trimInteractor = TrimInteractor(project: project)
        
        let duplicatePresenter = DuplicatePresenter()
        let duplicateInteractor = DuplicateInteractor(project: project)
        
        let splitPresenter = SplitPresenter()
        let splitInteractor = SplitInteractor(project: project)
        
        let settingsPresenter = SettingsPresenter()
        let settingsInteractor = SettingsInteractor()
        
        let detailTextPresenter = DetailTextPresenter()
        let detailTextInteractor = DetailTextInteractor()
        
        //RECORD MODULE
        recordPresenter.recordWireframe = recordWireframe
        recordPresenter.interactor = recordInteractor
        
        recordWireframe.recordPresenter = recordPresenter
        recordWireframe.rootWireframe = rootWireframe
        recordWireframe.editorRoomWireframe = editorRoomWireframe
        recordWireframe.settingsWireframe = settingsWireframe
        
        recordInteractor.project = project
        recordInteractor.delegate = recordPresenter
        
        //PLAYER MODULE
        playerPresenter.wireframe = playerWireframe
        playerPresenter.playerInteractor = playerInteractor
        
        playerWireframe.playerPresenter = playerPresenter
        
        //FILL SCREEN PLAYER MODULE
        fullScreenPlayerPresenter.wireframe = fullScreenPlayerWireframe
        
        fullScreenPlayerWireframe.fullScreenPlayerPresenter = fullScreenPlayerPresenter
        fullScreenPlayerWireframe.rootWireframe = rootWireframe
        
        //EDITOR ROOM MODULE
        editorRoomPresenter.wireframe = editorRoomWireframe
        editorRoomPresenter.interactor = editingRoomInteractor
        
        editorRoomWireframe.editingRoomPresenter = editorRoomPresenter
        editorRoomWireframe.rootWireframe = rootWireframe
        editorRoomWireframe.editorWireframe = editorWireframe
        editorRoomWireframe.shareWireframe = shareWireframe
        editorRoomWireframe.musicWireframe = musicWireframe
//        editorRoomWireframe.settingsWireframe = settingsWireframe
        editorWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe

        //EDITOR MODULE
        editorPresenter.wireframe = editorWireframe
        editorPresenter.playerPresenter = playerPresenter
        editorPresenter.playerWireframe = playerWireframe
        editorPresenter.interactor = editorInteractor
        
        editorWireframe.editorPresenter = editorPresenter
        editorWireframe.playerWireframe = playerWireframe
        editorWireframe.rootWireframe = rootWireframe
        editorWireframe.trimWireframe = trimWireframe
        editorWireframe.duplicateWireframe = duplicateWireframe
        editorWireframe.splitWireframe = splitWireframe
        editorWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        
        editorInteractor.delegate = editorPresenter
        editorInteractor.project = project
        
        //SHARE MODULE
        sharePresenter.wireframe = shareWireframe
        sharePresenter.recordWireframe = recordWireframe
        sharePresenter.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        sharePresenter.playerWireframe = playerWireframe
        sharePresenter.interactor = shareInteractor
        sharePresenter.playerPresenter = playerPresenter
        
        shareWireframe.sharePresenter = sharePresenter
        shareWireframe.rootWireframe = rootWireframe
        shareWireframe.playerWireframe = playerWireframe
        
        shareInteractor.project = project
        
        //MUSIC MODULE
        musicPresenter.wireframe = musicWireframe
        musicPresenter.interactor = musicInteractor
        musicPresenter.playerPresenter = playerPresenter
        musicPresenter.playerWireframe = playerWireframe
        
        musicInteractor.delegate = musicPresenter
        musicInteractor.project = project
        
        musicWireframe.musicPresenter = musicPresenter
        musicWireframe.rootWireframe = rootWireframe
        musicWireframe.playerWireframe = playerWireframe
        musicWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        musicWireframe.editorRoomWireframe = editorRoomWireframe
        
        //TRIM MODULE
        trimPresenter.interactor = trimInteractor
        
        trimWireframe.playerWireframe = playerWireframe
        trimWireframe.rootWireframe = rootWireframe
        trimWireframe.trimPresenter = trimPresenter
        trimWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        
        trimInteractor.delegate = trimPresenter
        trimInteractor.project = project
        
        //DUPLICATE MODULE
        duplicatePresenter.interactor = duplicateInteractor
        
        duplicateWireframe.playerWireframe = playerWireframe
        duplicateWireframe.rootWireframe = rootWireframe
        duplicateWireframe.duplicatePresenter = duplicatePresenter
        duplicateWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        
        duplicateInteractor.delegate = duplicatePresenter
        duplicateInteractor.project = project
        
        //SPLIT MODULE
        splitPresenter.interactor = splitInteractor
        
        splitWireframe.playerWireframe = playerWireframe
        splitWireframe.rootWireframe = rootWireframe
        splitWireframe.splitPresenter = splitPresenter
        splitWireframe.fullScreenPlayerWireframe = fullScreenPlayerWireframe
        
        splitInteractor.delegate = splitPresenter
        splitInteractor.project = project
        
        //SETTINGS MODULE
        settingsPresenter.wireframe = settingsWireframe
        settingsPresenter.recordWireframe = recordWireframe
        settingsPresenter.interactor = settingsInteractor
        settingsPresenter.detailTextWireframe = detailTextWireframe
        
        settingsWireframe.settingsPresenter = settingsPresenter
        settingsWireframe.rootWireframe = rootWireframe
        
        settingsInteractor.presenter = settingsPresenter
    
        //DETAIL TEXT MODULE
        detailTextPresenter.wireframe = detailTextWireframe
        detailTextPresenter.interactor = detailTextInteractor
        
        detailTextWireframe.detailTextPresenter = detailTextPresenter
        detailTextWireframe.rootWireframe = rootWireframe
    }
        
    func installRecordToRootViewControllerIntoWindow(window: UIWindow){
        recordWireframe.presentRecordInterfaceFromWindow(window)
    }
  
    func installEditorRoomToRootViewControllerIntoWindow(window: UIWindow){
        editorRoomWireframe.presentEditingRoomInterfaceFromWindow(window)
    }
}