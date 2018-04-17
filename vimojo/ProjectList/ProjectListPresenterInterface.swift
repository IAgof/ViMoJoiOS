//
//  ProjectListPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol ProjectListPresenterInterface {
    func viewWillAppear()

    func removeProject(projectNumber: Int)
    func duplicateProject(projectNumber: Int)
    func editProject(projectNumber: Int)
    func shareProject(projectNumber: Int)
    func projectDetails(projectNumber: Int)

    func pushBack()

}

protocol ProjectListPresenterDelegate {
    func setItems(_ items: [ProjectListViewModel])
}
