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
    
    func viewWillAppear() {
        interactor?.findProjects()
    }

    func reloadData(){
        interactor?.findProjects()
    }
    
    func pushBack() {
        wireframe?.goPrevController()
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
    
    func detailProject(projectNumber: Int) {
        interactor?.setProjectSelected(projectNumber: projectNumber)
        
        wireframe?.presentDetailProjectInterface()
    }
}

extension ProjectListPresenter:ProjectListInteractorDelegate{
    func setItemsView(_ items: [ProjectFound]) {
        var viewModelList:[ProjectListViewModel] = []
       
        if items.isEmpty{
            wireframe?.navigateToRecordOrGallery()
            return
        }
        
        for projectFound in items{
           viewModelList.append(ProjectListViewModel(videoURL: projectFound.videoURL,
                                 title: projectFound.title,
                                 date: projectFound.date,
                                 duration: projectFound.duration))
        }
        delegate?.setItems(viewModelList)
    }
    
    func editProjectFinished() {
        wireframe?.presentEditorInterface()
    }
    
    func shareProjectFinished() {
        wireframe?.presentShareInterface()
    }
}
