//
//  ProjectListInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject
import AVFoundation

class ProjectListInteractor: ProjectListInteractorInterface {
    var delegate: ProjectListInteractorDelegate?
    var projectList: [Project] = []
    var project: Project
    var selectedProjectUUID: String = ""

    init(project: Project) {
        self.project = project
    }

    func findProjects() {
        projectList = ProjectRealmRepository().getAllProjects()
        var projectFoundList: [ProjectFound] = []

        projectFoundList = projectList.map { setProjectFoundModel(project: $0) }

        delegate?.setItemsView(projectFoundList)
    }

    func setProjectFoundModel(project: Project) -> ProjectFound {
        let duration = project.getDuration()
        let title = project.getTitle()

        var videoURL: URL? = nil
        if let url = project.getVideoList().first?.videoURL {
            videoURL = url
        }

        var date = Date()
        if let dateDescription = project.modificationDate as? Date {
            date = dateDescription
        }

        return ProjectFound(videoURL: videoURL,
                            title: title,
                            date: date,
                            duration: duration)
    }

    func removeProjectAction(projectNumber: Int) {
        RemoveProjectOnProjectListAction().execute(completion: {haveToRemove in

            if haveToRemove {
                if self.projectList.indices.contains(projectNumber) {
                    let projectToRemove = self.projectList[projectNumber]

                    ProjectRealmRepository().remove(item: projectToRemove)

                    self.findProjects()

                    if projectToRemove.uuid == self.project.uuid {
                        self.project.clear()
                    }
                }
            }
        })
    }

    func editProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber) {
            let projectToLoad = projectList[projectNumber]
            projectToLoad.updateModificationDate()
            ProjectRealmRepository().update(item: projectToLoad)

            ReloadProjectWithProjectAction().reload(actualProject: project,
                                                    newProject: projectToLoad)

            delegate?.editProjectFinished()
        }
    }

    func duplicateProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber) {
            let project = projectList[projectNumber]
            DuplicateProjectOnProjectListAction().execute(project: project)
            self.findProjects()
        }
    }

    func shareProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber) {
            let projectToLoad = projectList[projectNumber]
            projectToLoad.updateModificationDate()
            ProjectRealmRepository().update(item: projectToLoad)

            ReloadProjectWithProjectAction().reload(actualProject: project,
                                                    newProject: projectToLoad)

            delegate?.shareProjectFinished()
        }
    }

    func setProjectSelected(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber) {
            self.selectedProjectUUID = self.projectList[projectNumber].uuid
        }
    }
}
