//
//  ProjectListPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class ProjectListPresenter:NSObject,ProjectListPresenterInterface{
    
    var delegate: ProjectListPresenterDelegate?
    var interactor: ProjectListInteractorInterface?
    
    var wireframe: ProjectListWireframe?

    func viewDidLoad() {
        interactor?.findProjects()
    }
    
    func reloadData(){
        interactor?.findProjects()
    }
    
    func removeProject(projectNumber: Int) {
        interactor?.removeProjectAction(projectNumber: projectNumber)
    }
    
    func editProject(projectNumber: Int) {
        interactor?.editProjectAction(projectNumber: projectNumber)
    }
    
    func shareProject(projectNumber: Int) {
        interactor?.shareProjectAction(projectNumber: projectNumber)
    }
    
    func duplicateProject(projectNumber: Int) {
        interactor?.duplicateProjectAction(projectNumber: projectNumber)
    }
}

extension ProjectListPresenter:ProjectListInteractorDelegate{
    func setItemsView(_ items: [ProjectListViewModel]) {
        delegate?.setItems(items)
        delegate?.reloadTableData()
    }
    
    func editProjectFinished() {
        wireframe?.presentEditorInterface()
    }
    
    func shareProjectFinished() {
        wireframe?.presentShareInterface()
    }
}
