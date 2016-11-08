//
//  RecorderInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 1/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class RecorderInteractor: RecorderInteractorInterface {
    
    var delegate:RecorderInteractorDelegate?
    var project:Project?

    func getNumberOfClipsInProject() -> Int {
        guard let numberOfClips = project?.numberOfClips() else{return 0}
        
        return numberOfClips
    }
    
    func getVideoURLInPosition(position: Int) -> NSURL {
        guard let videoURL = project?.getVideoList()[position].videoURL else{
            return NSURL()
        }
        
        return videoURL
    }
    
    func clearProject() {
        project?.clear()
    }
    
    func getProject() ->Project{
        return project!
    }
    
    func getResolutionImage(resolution: String) {
        let resolution = ResolutionImage(resolution: resolution)
        
        if let resImage = resolution.image{
            delegate?.resolutionImageFound(resImage)
        }
        
        if let resImagePressed = resolution.imagePressed{
            delegate?.resolutionImagePressedFound(resImagePressed)
        }
    }
}