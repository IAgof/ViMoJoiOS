//
//  DetailTextWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

let detailTextViewControllerIdentifier = "DetailTextController"

class DetailTextWireframe : NSObject {

    var rootWireframe : RootWireframe?
    var detailTextViewController : DetailTextController?
    var detailTextPresenter : DetailTextPresenter?
    
    var prevController:UIViewController?
    
    func presentShareInterfaceFromWindow(_ window: UIWindow) {
        let viewController = detailTextViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentDetailTextInterfaceFromViewController(_ prevController:UIViewController,textRef:String) {
        let viewController = detailTextViewControllerFromStoryboard()
        
        viewController.textRef = textRef
        
        self.prevController = prevController
        
        prevController.show(viewController, sender: nil)
    }
    
    func detailTextViewControllerFromStoryboard() -> DetailTextController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: detailTextViewControllerIdentifier) as! DetailTextController
        
        viewController.eventHandler = detailTextPresenter
        detailTextViewController = viewController
        detailTextPresenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    func goPrevController(){
        
        detailTextViewController?.navigationController?.popToViewController(prevController!, animated: true)
    }
}
