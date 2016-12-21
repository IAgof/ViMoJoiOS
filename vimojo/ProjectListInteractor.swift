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
    var delegate:ProjectListInteractorDelegate?
    var projectList:[Project] = []
    var project:Project
    
    init(project:Project) {
        self.project = project
    }
    
    func findProjects() {
        projectList = ProjectRealmRepository().getAllProjects()
        var projectViewModelList:[ProjectListViewModel] = []
        
        for project in projectList{
            projectViewModelList.append(setProjectViewModel(project: project))
        }
        
        delegate?.setItemsView(projectViewModelList)
    }
    
    
    func setProjectViewModel(project:Project)->ProjectListViewModel{
        let duration = Utils().hourToString(project.getDuration())
        let title = project.getTitle()
        let image = getProjectListThumbnail(project: project)
        var date = "No date"
        if let dateDescription = project.modificationDate?.description{
            date = dateDescription
        }
        
        return ProjectListViewModel(thumbImage: image,
                                    title: title,
                                    date: date,
                                    duration: duration)
    }
    
    func getProjectListThumbnail(project:Project)->UIImage{
        if let url = project.getVideoList().first?.videoURL{
            let asset = AVAsset(url: url)
            let assetImageGenerator = AVAssetImageGenerator(asset: asset)
            
            var time = asset.duration
            time.value = min(time.value, 1)
            
            do {
                let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
                return UIImage(cgImage: imageRef)
            } catch {
                print("error")
            }
        }
        return UIImage(named: "no_image")!
    }
    
    func removeProjectAction(projectNumber: Int) {
        RemoveProjectOnProjectListAction().execute(completion: {haveToRemove in

            if haveToRemove{
                if self.projectList.indices.contains(projectNumber){
                    ProjectRealmRepository().remove(item: self.projectList[projectNumber])
                    self.findProjects()
                }
            }
        })
    }
    
    func editProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber){
            let projectToLoad = projectList[projectNumber]
            ReloadProjectWithProjectAction().reload(actualProject: project,
                                                    newProject: projectToLoad)
            
            delegate?.editProjectFinished()
        }
    }
    
    func duplicateProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber){
            let project = projectList[projectNumber]
            DuplicateProjectOnProjectListAction().execute(project: project)
            self.findProjects()
        }
    }
    
    func shareProjectAction(projectNumber: Int) {
        if self.projectList.indices.contains(projectNumber){
            let projectToLoad = projectList[projectNumber]
            ReloadProjectWithProjectAction().reload(actualProject: project,
                                                    newProject: projectToLoad)
            
            delegate?.shareProjectFinished()
        }
    }
}

