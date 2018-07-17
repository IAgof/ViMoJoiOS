//
//  ProjectDetailsProtocols.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//


import Foundation
import VideonaProject
import CoreLocation

//MARK: Wireframe -
protocol ProjectDetailsWireframeProtocol: class {
    func dismiss()
    func goToSelectKindOfProject()
}
//MARK: Presenter -
protocol ProjectDetailsPresenterProtocol: class {
    func loadValues(loaded: (ProjectInfoVideoModel) -> Void)
    func saveValues(title: String?,
                    location: String?,
                    description: String?)
    func cancel()
    func getLocation(location: @escaping (String) -> Void)
    func goToSelectKindOfProject()
}

//MARK: Interactor -
protocol ProjectDetailsInteractorProtocol: class {
    
    var presenter: ProjectDetailsPresenterProtocol?  { get set }
    var project: Project { get set }
    func saveValues(title: String?,
                    location: String?,
                    description: String?)
    func getLocation(location: (CLLocation?) -> Void)
}

//MARK: View -
protocol ProjectDetailsViewProtocol: class {
    
    var presenter: ProjectDetailsPresenterProtocol?  { get set }
}
