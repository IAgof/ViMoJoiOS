//
//  SettingsInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SettingsInteractorInterface {
    func findSettings()
    func executeSettingAtIndexPath(index:NSIndexPath)
}

protocol SettingsInteractorDelegate {
    func setSectionsToView(sections:[String])
    func setSettingsItemsView(items:[[SettingsViewModel]])
}