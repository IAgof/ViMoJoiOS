//
//  SettingsFTP.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct SettinsFTP {
    var host:String = ""
    var username:String = ""
    var password:String = ""
    var editedVideoPath:String = ""
    var uneditedVideoPath:String = ""

    init(){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let hostSaved = defaults.stringForKey(SettingsConstants().SETTINGS_HOST_FTP){
            host = hostSaved
        }
        if let usernameSaved = defaults.stringForKey(SettingsConstants().SETTINGS_USERNAME_FTP){
            username = usernameSaved
        }
        
        if let passwordSaved = defaults.stringForKey(SettingsConstants().SETTINGS_PASSWORD_FTP){
            if passwordSaved != ""{
                password = passwordSaved
            }else{
                password = "********"
            }
        }
        
        if let editedVideoPathSaved = defaults.stringForKey(SettingsConstants().SETTINGS_EDITED_DEST_FTP){
            editedVideoPath = editedVideoPathSaved
        }
        
        if let uneditedVideoPathtSaved = defaults.stringForKey(SettingsConstants().SETTINGS_UNEDITED_DEST_HOST_FTP){
            uneditedVideoPath = uneditedVideoPathtSaved
        }
    }
}