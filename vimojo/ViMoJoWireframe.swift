//
//  ViMoJoWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 1/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

public class ViMoJoWireframe:ViMoJoWireframeInterface{
    var storyBoardName = "Main"
    var rootWireframe : RootWireframe?
    var viewController : ViMoJoController?
    var presenter : ViMoJoPresenterInterface?
    
    var prevController:UIViewController?
    
    func presentInterfaceFromWindow(_ window: UIWindow) {
        let viewController = viewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentInterfaceFromViewController(_ prevController:UIViewController) {
        let viewController = viewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func viewControllerFromStoryboard() -> ViMoJoController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: projectListViewControllerIdentifier) as! ViMoJoController
        
        viewController.eventHandler = presenter
        self.viewController = viewController
        presenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        viewController?.dismiss(animated: false, completion: nil)
    }
}
