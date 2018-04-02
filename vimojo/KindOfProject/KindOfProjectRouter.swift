//
//  KindOfProjectRouter.swift
//  vimojo
//
//  Created Jesus Huerta on 02/04/2018.
//  Copyright © 2018 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class KindOfProjectRouter: KindOfProjectWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = KindOfProjectViewController(nibName: nil, bundle: nil)
        let interactor = KindOfProjectInteractor()
        let router = KindOfProjectRouter()
        let presenter = KindOfProjectPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
