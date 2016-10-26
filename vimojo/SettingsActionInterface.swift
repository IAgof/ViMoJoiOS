//
//  SettingsActionInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SettingsActionInterface {
    func executeSettingsAction(index:NSIndexPath)
    var delegate:SettingsActionDelegate {get set}
}

protocol SettingsActionDelegate {
    func executeFinished()
}

protocol SettingsActionDetailTextDelegate:SettingsActionDelegate {
    func setTextToDetailView(response:SettingsActionDetailTextResponse)
}

protocol SettingsActionResponse {

}

struct SettingsActionDetailTextResponse:SettingsActionResponse {
    var text:String
}

