//
//  SettingsContent.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 17/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct SettingsContent{
    var title:String = ""
    var subTitle:String = ""
    var action:SettingsActionInterface?
    
    init(title:String, subTitle:String,action:SettingsActionInterface) {
        self.title = title
        self.subTitle = subTitle
        self.action = action
    }
    
    init(title:String,action:SettingsActionInterface) {
        self.title = title
        self.subTitle = ""
        self.action = action
    }
}