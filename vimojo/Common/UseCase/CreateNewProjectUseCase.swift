//
//  CreateNewProjectUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class CreateNewProjectUseCase {
    func create( project: Project) {
        project.clear()

        ProjectRealmRepository().add(item: project)
    }
}
