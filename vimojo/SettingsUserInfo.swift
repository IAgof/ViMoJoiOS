//
//  SettingsUserInfo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct userInfo {
    var name:String
    var userName:String
    var email:String
    init(){
        let defaults = UserDefaults.standard
        
        let nameSaved = defaults.string(forKey: SettingsConstants().SETTINGS_NAME)
        if (nameSaved != nil){
            name = nameSaved!
        }else{
            name = ""
        }
        
        let userNameSaved = defaults.string(forKey: SettingsConstants().SETTINGS_USERNAME)
        if (userNameSaved != nil){
            userName = userNameSaved!
        }else{
            userName = ""
        }
        
        let emailSaved = defaults.string(forKey: SettingsConstants().SETTINGS_MAIL)
        if (emailSaved != nil){
            email = emailSaved!
        }else{
            email = ""
        }
    }
}
