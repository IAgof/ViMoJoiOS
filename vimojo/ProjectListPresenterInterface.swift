//
//  ProjectListPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ProjectListPresenterInterface {
    func viewDidLoad()
    
    func removeProject(projectNumber:Int)
    func duplicateProject(projectNumber:Int)
    func editProject(projectNumber:Int)
    func shareProject(projectNumber:Int)
}

protocol ProjectListPresenterDelegate{
    func reloadTableData()
    func setNavBarTitle(_ title:String)
    
    func setItems(_ items:[ProjectListViewModel])
}
