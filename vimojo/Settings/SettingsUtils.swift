//
//  SettingsUtils.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject


class SettingsUtils {
    func createAlertViewWithInputText(_ title:String,
                                      message:String,
                                      completion: @escaping (String) -> Void)-> UIAlertController{
        let saveString = Utils().getStringByKeyFromSettings(SettingsConstants().SAVE)
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setTintColor()

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = title
        }
        
        let saveAction = UIAlertAction(title: saveString, style: .default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func createAlertViewWithInputTextSecure(_ title:String,
                                      message:String,
                                      completion: @escaping (String) -> Void)-> UIAlertController{
        let saveString = Utils().getStringByKeyFromSettings(SettingsConstants().SAVE)
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.setTintColor()

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = title
            textField.isSecureTextEntry = true
        }
        
        let saveAction = UIAlertAction(title: saveString, style: .default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }
    
    func createActionSheetWithOptions(_ title: String,
                                      options: Array<String>,
                                      completion: @escaping (String) -> Void)-> UIAlertController {
        let title = title
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alertController.setTintColor()

        for option in options {
            let optionAction = UIAlertAction(title: option, style: .default, handler: {alert -> Void in

                print("El \(title) introducido para mandar al presenter es: \(option)")
                completion(option)
            })
            alertController.addAction(optionAction)
        }
        
        let optionAction = UIAlertAction(title: cancelString,
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(optionAction)
        
        return alertController
    }
}
