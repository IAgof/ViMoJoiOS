//
//  ProjectListInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ProjectListInteractorInterface {
    func findProjects()
    
    func removeProjectAction(projectNumber:Int)
    func duplicateProjectAction(projectNumber:Int)
    func editProjectAction(projectNumber:Int)
    func shareProjectAction(projectNumber:Int)
}

protocol ProjectListInteractorDelegate {
    func setItemsView(_ items:[ProjectListViewModel])
}
