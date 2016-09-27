//
//  AddTextWireframe.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

import Foundation
import UIKit

let addTextViewControllerIdentifier = "AddTextViewController"

class AddTextWireframe : NSObject {
    
    var rootWireframe : RootWireframe?
    var addTextViewController : AddTextViewController?
    var addTextPresenter : AddTextPresenter?
    
    var prevController:UIViewController?
    
    func presentShareInterfaceFromWindow(window: UIWindow) {
        let viewController = addTextViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    
    func presentShareInterfaceFromViewController(prevController:UIViewController,textRef:String) {
        let viewController = addTextViewControllerFromStoryboard()
        
        self.prevController = prevController
        
        prevController.showViewController(viewController, sender: nil)
    }
    
    func addTextViewControllerFromStoryboard() -> AddTextViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewControllerWithIdentifier(addTextViewControllerIdentifier) as! AddTextViewController
        
        viewController.eventHandler = addTextPresenter
        addTextViewController = viewController
        addTextPresenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        return storyboard
    }
    
    func goPrevController(){
        addTextViewController?.navigationController?.popToViewController(prevController!, animated: true)
    }
}