//
//  SettingsPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsPresenter:NSObject,SettingsPresenterInterface{
    
    var delegate: SettingsPresenterDelegate?
    var interactor: SettingsInteractorInterface?

    var wireframe: SettingsWireframe?
    var detailTextWireframe: DetailTextWireframe?
    var recordWireframe: RecordWireframe?

    let kamaradaAppleStoreURL = Utils().getStringByKeyFromSettings(SettingsConstants().KAMARADA_ITUNES_LINK)
    let videonaTwitterUser = Utils().getStringByKeyFromSettings(SettingsConstants().VIDEONA_TWITTER_USER)
    
    func pushBack() {
        wireframe?.goPrevController()
    }
    
    func viewDidLoad() {
        delegate?.setNavBarTitle(Utils().getStringByKeyFromSettings(SettingsConstants().SETTINGS_TITLE))
        delegate?.registerClass()
        delegate?.removeSeparatorTable()
        
        interactor?.findSettings()
        delegate?.addFooter()
    }
    
    func itemListSelected(index: NSIndexPath) {
        interactor?.executeSettingAtIndexPath(index)
    }
    
    func reloadData(){
        //Reload data
        interactor?.findSettings()
        
        delegate?.reloadTableData()
    }
}

extension SettingsPresenter:SettingsInteractorDelegate{
    func setSettingsItemsView(items: [[SettingsViewModel]]) {
        delegate?.setItems(items)
        delegate?.reloadTableData()
    }
    
    func setSectionsToView(sections: [String]) {
        delegate?.setSectionsArray(sections)
    }
}