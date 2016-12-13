//
//  DrawerMenuPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class DrawerMenuPresenter: DrawerMenuPresenterInterface {
    
    var delegate: DrawerMenuPresenterDelegate?
    var wireframe: DrawerMenuWireframe?
    var interactor: DrawerMenuInteractorInterface?
    
    enum cellType:Int {
        case projects = 0
        case newProject = 1
        case options = 2
    }
    let optionsSection = 1
    
    func didSelectAtIndexPath(indexPath: IndexPath) {
        delegate?.closeDrawer()
        if indexPath.section == optionsSection{
            if let row = cellType(rawValue: indexPath.item){
                switch row {
                case .projects:
                    wireframe?.presentProjectsSelector()
                    break
                case .newProject:
                    interactor?.createNewProject()
                    delegate?.layoutDrawerControllerView()
                    break
                case .options:
                    wireframe?.presentSettings()
                    break
                }
            }
        }
    }
    
    func exitPushed() {
        delegate?.closeDrawer()
    }
}

extension DrawerMenuPresenter:DrawerMenuInteractorDelegate{
    
}
