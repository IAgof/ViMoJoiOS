//
//  SettingsNameAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsNameAction: SettingsActionInterface {
    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction() {
        let saveString = "Save"
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_NAME)
        let message = Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_NAME)
        
        let alertController = SettingsUtils().createAlertViewWithInputText(title,
                                                                           message: message,
                                                                           buttonText: saveString,
                                                                           completion: {
                                                                            text in
                                                                            self.saveNameOnDefaults(text)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
        
    func saveNameOnDefaults(saveString:String){ 
        defaults.setObject(saveString, forKey: SettingsConstants().SETTINGS_NAME)
        let response = SettingsActionUpdateTableResponse()
        delegate.executeFinished(response)
    }
}