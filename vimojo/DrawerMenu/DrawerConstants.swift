//
//  DrawerConstants.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

struct DrawerConstants {
    var ACTIVITY_DRAWER_ALERT_TITLE: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_title")
    }
    var ACTIVITY_DRAWER_ALERT_MESSAGE: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_message")
    }
    var ACTIVITY_DRAWER_ALERT_OPTION_TAKE_PHOTO: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_option_take_photo")
    }
    var ACTIVITY_DRAWER_ALERT_OPTION_TAKE_FROM_GALLERY: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_option_take_from_gallery")
    }
    var ACTIVITY_DRAWER_ALERT_OPTION_CANCEL: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_option_cancel")
    }
    var ACTIVITY_DRAWER_ALERT_OPTION_REMOVE: String {
        return getStringByKeyFromDrawer("activity_drawer_alert_option_remove")
    }

    func getStringByKeyFromDrawer(_ key: String) -> String {
        return Bundle.main.localizedString(forKey: key, value: "", table: "DrawerMenu")
    }
}
