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
        
        if let hostSaved = defaults.stringForKey(SettingsConstants().HOST_FTP){
            host = hostSaved
        }
        if let usernameSaved = defaults.stringForKey(SettingsConstants().FTP_USERNAME){
            username = usernameSaved
        }
        
        if let passwordSaved = defaults.stringForKey(SettingsConstants().PASSWORD_FTP){
            if passwordSaved == ""{
                password = passwordSaved
            }else{
                password = "********"
            }
        }
        
        if let editedVideoPathSaved = defaults.stringForKey(SettingsConstants().EDITED_VIDEO_DESTINATION){
            editedVideoPath = editedVideoPathSaved
        }
        
        if let uneditedVideoPathtSaved = defaults.stringForKey(SettingsConstants().UNEDITED_VIDEO_DESTINATION){
            uneditedVideoPath = uneditedVideoPathtSaved
        }
    }
}