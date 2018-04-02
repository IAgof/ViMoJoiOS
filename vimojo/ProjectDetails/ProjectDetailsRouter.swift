//
//  ProjectDetailsRouter.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import VideonaProject

class ProjectDetailsRouter: ProjectDetailsWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(with project: Project) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = ProjectDetailsViewController(nibName: nil, bundle: nil)
        let interactor = ProjectDetailsInteractor(project: project)
        let router = ProjectDetailsRouter()
        let presenter = ProjectDetailsPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    func dismiss() {
        viewController?.navigationController?.popViewController()
    }
    func goToSelectKindOfProject() {
        if let controller = UIApplication.topViewController() {
            controller.show(KindOfProjectRouter.createModule(), sender: nil)
        }
    }
}
