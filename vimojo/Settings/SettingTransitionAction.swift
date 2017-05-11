//
//  SettingTransitionAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 2/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

struct SettingsTransitionActionResponse:SettingsActionResponse {
    var transitionTime:Double
}

class SettingsTransitionAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate
    var project:Project

    init(delegate:SettingsActionDelegate,
         project:Project){
        self.delegate = delegate
        self.project = project
    }
    
    func executeSettingsAction(_ index:IndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().TRANSITION)
        
        let options = SettingsTransition(project: project).getAllTransitionsToView()
        let alertController = SettingsUtils().createActionSheetWithOptions(title,
                                                                           options: options,
                                                                           completion: {
                                                                            response in
                                                                            self.saveOnDefaults(response)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = settingsController.settingsTableView.cellForRow(at: index)
            }
            settingsController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveOnDefaults(_ saveString:String){
        let transition = SettingsTransition(project: project)
        transition.save(value: saveString)
        
        project.transitionTime = transition.transitionTime
        ProjectRealmRepository().update(item: project)

        delegate.executeFinished()
    }
}
