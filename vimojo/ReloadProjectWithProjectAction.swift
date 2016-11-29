//
//  ReloadProjectWithProjectAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class ReloadProjectWithProjectAction {
    func reload(actualProject:Project,
                newProject:Project){
        
        actualProject.reloadProjectWith(project: newProject)
    }
}
