//
//  SettingsPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SettingsPresenterInterface {

    func pushBack()
    func viewDidLoad()
    func itemListSelected(_ index: IndexPath)
}

protocol SettingsPresenterDelegate {
    func registerClass()
    func reloadTableData()
    func removeSeparatorTable()
    func addFooter()

    func setSectionsArray(_ sections: [String])
    func setItems(_ items: [[SettingsViewModel]])
}
