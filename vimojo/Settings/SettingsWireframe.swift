//
//  SettingsWireframe.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

let settingsViewControllerIdentifier = "SettingsViewController"

class SettingsWireframe : NSObject {
    var rootWireframe : RootWireframe?
    var settingsViewController : SettingsViewController?
    var settingsPresenter : SettingsPresenter?
    var detailTextWireframe : DetailTextWireframe?
    
    var prevController:UIViewController?

    func presentSettingsInterfaceFromWindow(_ window: UIWindow) {
        let viewController = settingsViewControllerFromStoryboard()
        
        rootWireframe?.showRootViewController(viewController, inWindow: window)
    }
    func setSettingsViewControllerAsRootController() {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let homeViewController =  settingsViewControllerFromStoryboard()
        let nav = UINavigationController(rootViewController: homeViewController)
        appdelegate.window!.rootViewController = nav
    }
    
    func presentSettingsInterfaceFromViewController(_ prevController:UIViewController){
        let viewController = settingsViewControllerFromStoryboard()
        
        self.prevController = prevController

        prevController.show(viewController, sender: nil)
    }
    
    func settingsViewControllerFromStoryboard() -> SettingsViewController {
        let storyboard = mainStoryboard()
        let viewController = storyboard.instantiateViewController(withIdentifier: settingsViewControllerIdentifier) as! SettingsViewController
        
        viewController.eventHandler = settingsPresenter
        settingsViewController = viewController
        settingsPresenter?.delegate = viewController
        
        return viewController
    }
    
    func mainStoryboard() -> UIStoryboard {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard
    }
    
    func presentDetailTextController(_ textViewText:String){
        detailTextWireframe?.presentDetailTextInterfaceFromViewController(settingsViewController!,
                                                                     textRef: textViewText)
    }
    
    func goPrevController(){
        if let controller = prevController{
            if controller.isBeingPresented{
                self.settingsViewController?.present(controller, animated: true, completion: nil)
            }else{
                self.settingsViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    func goToAppleStoreURL(_ url:URL){
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }
    }
    
    func goToTwitterUserPage(_ user:String){
        let twitterURL = URL(string: "twitter://user?screen_name=\(user)")
        
        if UIApplication.shared.canOpenURL(twitterURL!){
            UIApplication.shared.openURL(twitterURL!)
        }else{
            let twitterBrowserURL = URL(string: "http://www.twitter.com/\(user)")
            UIApplication.shared.openURL(twitterBrowserURL!)
        }
    }
}
