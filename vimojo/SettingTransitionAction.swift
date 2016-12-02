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
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction(_ index:IndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().TRANSITION)
        
        let options = SettingsTransition().getAllTransitionsToView()
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
        let transition = SettingsTransition()
        transition.save(value: saveString)
        delegate.executeFinished(response: SettingsTransitionActionResponse(transitionTime: transition.transitionTime))
    }
}
