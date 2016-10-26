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
    func itemListSelected(index:NSIndexPath)
}

protocol SettingsPresenterDelegate{
    func registerClass()
    func reloadTableData()
    func removeSeparatorTable()
    func setNavBarTitle(title:String)
    func addFooter()
    
    func setSectionsArray(sections:[String])
    func setItems(items:[[SettingsViewModel]])
}