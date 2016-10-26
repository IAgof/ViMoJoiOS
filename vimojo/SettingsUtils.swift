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
                                      buttonText:String,
                                      completion: String -> Void)-> UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = title
        }
        
        let saveAction = UIAlertAction(title: buttonText, style: .Default, handler: {alert -> Void in
            guard let firstTextFieldText = (alertController.textFields![0] as UITextField).text else{return}
            completion(firstTextFieldText)
        })
        
        alertController.addAction(saveAction)
        
        return alertController
    }
    
    func createActionSheetWithOptions(title: String,
                                      options: Array<String>,
                                      buttonText:String,
                                      completion: String -> Void)-> UIAlertController {
        let title = title
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .ActionSheet)
        
        for option in options {
            let optionAction = UIAlertAction(title: option, style: .Default, handler: {alert -> Void in

                print("El \(title) introducido para mandar al presenter es: \(option)")
                completion(option)
            })
            alertController.addAction(optionAction)
        }
        
        let optionAction = UIAlertAction(title: buttonText,
                                         style: .Cancel,
                                         handler: nil)
        
        alertController.addAction(optionAction)
        
        return alertController
    }
}