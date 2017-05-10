//
//  ProjectListConstants.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 21/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

struct ProjectListConstants{
    static var REMOVE_PROJECT_ALERT_TITLE:String{
        return getStringByKeyFromDrawer("remove_project_alert_title")
    }
    static var REMOVE_PROJECT_ALERT_YES_BUTTON:String{
        return getStringByKeyFromDrawer("remove_project_alert_yes_button")
    }
    static var REMOVE_PROJECT_ALERT_NO_BUTTON:String{
        return getStringByKeyFromDrawer("remove_project_alert_no_button")
    }
    static var PROJECT_LIST_DURATION_PREFIX:String{
        return getStringByKeyFromDrawer("project_list_duration_prefix")
    }
    static var PROJECT_LIST_DATE_PREFIX:String{
        return getStringByKeyFromDrawer("project_list_date_prefix")
    }

    static func getStringByKeyFromDrawer(_ key:String) -> String {
        return Bundle.main.localizedString(forKey: key,value: "",table: "ProjectList")
    }
}
