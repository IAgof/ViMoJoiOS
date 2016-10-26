//
//  SettingsUtils.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


class SettingsUtils {
    func createAlertViewWithInputText(title:String,
                                      message:String,
                                      completion: String -> Void)-> UIAlertController{
        let saveString = Utils().getStringByKeyFromSettings(SettingsConstants().SAVE)
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = title
        }
        
        let saveAction = UIAlertAction(title: saveString, style: .Default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .Cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func createAlertViewWithInputTextSecure(title:String,
                                      message:String,
                                      completion: String -> Void)-> UIAlertController{
        let saveString = Utils().getStringByKeyFromSettings(SettingsConstants().SAVE)
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = title
            textField.secureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: saveString, style: .Default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .Cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func createActionSheetWithOptions(title: String,
                                      options: Array<String>,
                                      completion: String -> Void)-> UIAlertController {
        let title = title
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title: option, style: .Default, handler: {alert -> Void in

                print("El \(title) introducido para mandar al presenter es: \(option)")
                completion(option)
            })
            alertController.addAction(optionAction)
        }
        
        let optionAction = UIAlertAction(title: cancelString,
                                         style: .Cancel,
                                         handler: nil)
        
        alertController.addAction(optionAction)
        
        return alertController
    }
}