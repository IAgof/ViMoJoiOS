//
//  EditingRoomInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class EditingRoomInteractor:EditingRoomInteractorInterface{
    
    var project:Project
    
    init(project:Project){
        self.project = project
    }
    
    public func getProject() -> Project {
        return project
    }
    
    public func getNumberOfClips() -> Int {
        return project.numberOfClips()
    }
}