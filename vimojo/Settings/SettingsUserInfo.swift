//
//  SettingsUserInfo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct userInfo {
    var name: String
    var userName: String
    var email: String
    var image: UIImage

    init() {
        let defaults = UserDefaults.standard

        let nameSaved = defaults.string(forKey: SettingsConstants().SETTINGS_NAME)
        if (nameSaved != nil) {
            name = nameSaved!
        } else {
            name = ""
        }

        let userNameSaved = defaults.string(forKey: SettingsConstants().SETTINGS_USERNAME)
        if (userNameSaved != nil) {
            userName = userNameSaved!
        } else {
            userName = ""
        }

        let emailSaved = defaults.string(forKey: SettingsConstants().SETTINGS_MAIL)
        if (emailSaved != nil) {
            email = emailSaved!
        } else {
            email = ""
        }

        let photoSavedData = defaults.data(forKey: SettingsConstants().SETTINGS_PHOTO_USER)
        if let photoWithData = photoSavedData {
            if let photoSaved = UIImage(data:photoWithData) {
                image = photoSaved
            } else {
                image = #imageLiteral(resourceName: "activity_drawer_no_user_photo")
            }
        } else {
            image = #imageLiteral(resourceName: "activity_drawer_no_user_photo")
        }
    }
}
