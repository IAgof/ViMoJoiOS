//
//  SettingsEmailAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsEmailAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction(_ index:IndexPath) {

        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_MAIL)
        
        let alertController = SettingsUtils().createAlertViewWithInputText(title,
                                                                           message: "",
                                                                           completion: {
                                                                            text in
                                                                            
                                                                            if self.isValidEmail(text){
                                                                                self.saveOnDefaults(text)
                                                                            }else{
                                                                                //TODO: Crear la alerta de email no vali
                                                                            }
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {            
            settingsController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func saveOnDefaults(_ saveString:String){
        defaults.set(saveString, forKey: SettingsConstants().SETTINGS_MAIL)
        delegate.executeFinished()
    }
}
