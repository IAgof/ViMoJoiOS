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
        checkWatermarkStatus(project: project)
        ProjectRealmRepository().add(item: project)
    }
}

func checkWatermarkStatus(project: Project) {
    if !configuration.IS_WATERMARK_SWITCHABLE && !configuration.IS_WATERMARK_PURCHABLE {
        project.hasWatermark = configuration.IS_WATERMARK_ENABLED
    }
}
