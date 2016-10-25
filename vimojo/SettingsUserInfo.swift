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
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let nameSaved = defaults.stringForKey(SettingsConstants().SETTINGS_NAME)
        if (nameSaved != nil){
            name = nameSaved!
        }else{
            name = ""
        }
        
        let userNameSaved = defaults.stringForKey(SettingsConstants().SETTINGS_USERNAME)
        if (userNameSaved != nil){
            userName = userNameSaved!
        }else{
            userName = ""
        }
        
        let emailSaved = defaults.stringForKey(SettingsConstants().SETTINGS_MAIL)
        if (emailSaved != nil){
            email = emailSaved!
        }else{
            email = ""
        }
    }
}
