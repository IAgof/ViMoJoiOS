//
//  SettingsUsernameAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsUsernameAction: SettingsActionInterface {
    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction() {
        let saveString = "Save"
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_USER_NAME)
        let message =   Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_USER_NAME)
        
        let alertController = SettingsUtils().createAlertViewWithInputText(title,
                                                                           message: message,
                                                                           buttonText: saveString,
                                                                           completion: {
                                                                            text in
                                                                            self.saveUserNameOnDefaults(text)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func saveUserNameOnDefaults(saveString:String){ 
        defaults.setObject(saveString, forKey: SettingsConstants().SETTINGS_USERNAME)
        let response = SettingsActionUpdateTableResponse()
        delegate.executeFinished(response)
    }
}