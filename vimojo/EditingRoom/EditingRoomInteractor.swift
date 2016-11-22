//
//  EditingRoomInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

open class EditingRoomInteractor:EditingRoomInteractorInterface{
    
    var project:Project
    
    init(project:Project){
        self.project = project
    }
    
    open func getProject() -> Project {
        return project
    }
    
    open func getNumberOfClips() -> Int {
        return project.numberOfClips()
    }
}
