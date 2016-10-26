//
//  SettingsQualityAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SettingsQualityAction: SettingsActionInterface {
    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction() {
        let optionsButtonText = "Cancel"
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_USER_NAME)
        
        let options = AVQualityParse().qualityToView()
        let alertController = SettingsUtils().createActionSheetWithOptions(title,
                                                                           options: options,
                                                                           buttonText: optionsButtonText,
                                                                           completion: {
                                                                            response in
                                                                            self.saveQualityOnDefaults(response)
        })
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func saveQualityOnDefaults(saveString:String){ 
        defaults.setObject(saveString, forKey: SettingsConstants().SETTINGS_QUALITY)
        let response = SettingsActionUpdateTableResponse()
        delegate.executeFinished(response)
    }
}