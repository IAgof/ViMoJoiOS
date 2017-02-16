//
//  AddFilterToVideoWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject


class AddFilterToVideoWireframe : VimojoWireframeInterface {
    typealias presenterType = AddFilterToVideoPresenter
    typealias viewControllerType = AddFilterToVideoViewController
    
    var rootWireframe : RootWireframe?
    var viewController : viewControllerType?
    var presenter: presenterType?
    
    var prevController:UIViewController?
    var viewControllerIdentifier: String
    var storyboardName: String
    var playerWireframe: PlayerWireframe?
    var editingRoomWireframe:EditingRoomWireframe?

    private var videoSelectedUUID:String?
    
    init() {
        viewControllerIdentifier = "AddFilterToVideoViewController"
        storyboardName = "Editor"
    }
    
    func presentInterfaceFromWindow(_ window: UIWindow) {
        let viewController = viewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentInterfaceFromViewController(_ prevController: UIViewController) {
        let viewController = viewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func presentPlayerInterface() {
        playerWireframe?.presentPlayerInterfaceFromViewController(viewController!)
    }
    
    func viewControllerFromStoryboard() -> viewControllerType {
        let storyboard = getStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! viewControllerType
        
        self.viewController = viewController
        
        viewController.eventHandler = presenter
        
        presenter?.delegate = viewController
        
        return viewController
    }
    
    func getStoryboard() -> UIStoryboard{
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        self.viewController?.navigationController?.popViewController()
    }
    
    func presentSettings(){
        editingRoomWireframe?.navigateToSettings()
    }
}
