//
//  ProjectListWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


let projectListViewControllerIdentifier = "ProjectListViewController"

class ProjectListWireframe : ViMoJoWireframe {
    var editorRoomWireframe: EditingRoomWireframe?

    override init(){
        storyBoardName = "ProjectList"
    }
    
    func presentEditorInterface(){
        if viewController != nil{
            editorRoomWireframe?.presentEditingRoomInterfaceFromViewController(viewController!)
        }
    }
    
    func presentShareInterface(){
        if viewController != nil{
            editorRoomWireframe?.presentEditingRoomFromViewControllerAndExportVideo(viewController!)
        }
    }
}
