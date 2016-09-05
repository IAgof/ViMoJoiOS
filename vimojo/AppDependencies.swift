//
//  AppDependencies.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 3/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import Project

class AppDependencies {
    var project = Project()
    
    var recordWireframe = RecordWireframe()
    
    init(){
        configureDependencies()
    }

    func configureDependencies(){
        let rootWireframe = RootWireframe()
        
        let recordPresenter = RecordPresenter()
        let recordInteractor = RecorderInteractor()

        //RECORD MODULE
        recordPresenter.recordWireframe = recordWireframe
        recordPresenter.interactor = recordInteractor
        
        recordWireframe.recordPresenter = recordPresenter
        recordWireframe.rootWireframe = rootWireframe
        
        recordInteractor.project = project
        
    }
        
    func installRecordToRootViewControllerIntoWindow(window: UIWindow){
        recordWireframe.presentRecordInterfaceFromWindow(window)
    }
  
}