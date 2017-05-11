//
//  ProjectRepository.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public protocol ProjectRepository:Repository{
    typealias T = Project
    
    func getCurrentProject()->Project
    func duplicateProject(id:String)
    func getAllProjects()->[Project]
    func getProjectByUUID (uuid:String)->Project?
}
