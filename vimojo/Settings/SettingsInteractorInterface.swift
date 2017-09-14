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
    func executeSettingAtIndexPath(_ index: IndexPath)
}

protocol SettingsInteractorDelegate {
    func setSectionsToView(_ sections: [String])
    func setSettingsItemsView(_ items: [[SettingsViewModel]])
    func goToDetailTextController(_ text: String)
}
