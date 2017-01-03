//
//  SettingsInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import VideonaProject

class SettingsInteractor: NSObject,SettingsInteractorInterface {
    
    var delegate:SettingsInteractorDelegate?
    
    var orderArray = Dictionary<Int,String>()
    let defaults = UserDefaults.standard

    var settingSelected:SettingsContent?
    
    var settings:[[SettingsContent]]?
    var sections:[String]?
    var project :Project?
    
    init(project:Project){
        self.project = project
    }
    
    func findSettings(){
        guard let actualProject = project else{return}
        
        self.settings = SettingsProvider().getSettings(self,project: actualProject)
        self.sections = SettingsProvider().getSections()
        
        if let sectionsArray = self.sections{
            delegate?.setSectionsToView(sectionsArray)
        }
        
        self.inflateSettingsViewModel()
    }
    
    func inflateSettingsViewModel(){
        var settingsViewModelArray = Array<Array<SettingsViewModel>>()
        
        if let settingsArray = self.settings{
            for settingRow in settingsArray{
                var settingRowViewModel = Array<SettingsViewModel>()
                
                for setting in settingRow{
                    settingRowViewModel.append(SettingsViewModel(title: setting.title,
                        subtitle: setting.subTitle))
                }
                settingsViewModelArray.append(settingRowViewModel)
            }
        }
        delegate?.setSettingsItemsView(settingsViewModelArray)
    }
    
    func executeSettingAtIndexPath(_ index: IndexPath) {
        guard let setting = settings?[index.section][index.item] else { return}
        setting.action?.executeSettingsAction(index)
    }
    
    //MARK: - AVResolution posible inputs
    func getAVResolutions()->Array<String>{
        let resolutions = AVResolutionParse().resolutionsToView()
        
        return resolutions
    }

    func setSettingSelected() {
        self.settingSelected = nil
    }
}

extension SettingsInteractor:SettingsActionDelegate{
    func executeFinished() {
        self.findSettings()
    }
    
    func executeFinished(response: SettingsActionResponse) {
        self.findSettings()
    }
}

extension SettingsInteractor:SettingsActionDetailTextDelegate{
    func setTextToDetailView(_ response: SettingsActionDetailTextResponse) {

        delegate?.goToDetailTextController(response.text)
    }
}
