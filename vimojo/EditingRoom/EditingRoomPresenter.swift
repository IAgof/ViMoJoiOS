//
//  EditingRoomPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class EditingRoomPresenter: NSObject,EditingRoomPresenterInterface {
    
    //MARK: - Variables VIPER
    var controller: EditingRoomViewInterface?
    var wireframe: EditingRoomWireframe?
    
    //MARK: Variables
    enum controllerVisible:Int {
        case editor = 1
        case music = 2
        case share = 3
    }
    
    var whatControllerIsVisible:controllerVisible = .editor
    
    func loadView() {
        wireframe?.initTabBarControllers()
    }
    
    func controllerSelectedTag(tag: Int) {
        if let controllerVisible = controllerVisible(rawValue: tag){
            whatControllerIsVisible = controllerVisible
            
            switch whatControllerIsVisible {
            case .editor:

                break
            case .music:
                
                break
            case .share:
                
                break
            }
        }
    }
}
