//
//  SettingsFTPPasswordAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsFTPPasswordAction: SettingsActionInterface {
    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction(index:NSIndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_PASSWORD_FTP)
        
        let alertController = SettingsUtils().createAlertViewWithInputTextSecure(title,
                                                                           message: "",
                                                                           completion: {
                                                                            text in
                                                                            self.saveOnDefaults(text)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func saveOnDefaults(saveString:String){
        defaults.setObject(saveString, forKey: SettingsConstants().SETTINGS_HOST_FTP)
        delegate.executeFinished()
    }
}