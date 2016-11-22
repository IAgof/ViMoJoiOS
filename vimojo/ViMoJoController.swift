//
//  ViMoJoController.swift
//  ViMoJo
//
//  Created by Alejandro Arjonilla Garcia on 24/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit
import Mixpanel


let VIMOJO_GREEN_UICOLOR = UIColor.init(red: 0.2431, green: 0.9764, blue: 0.8039, alpha: 1.0)
let VIMOJO_RED_UICOLOR = UIColor.init(red: 0.9450, green: 0.2941, blue: 0.3176, alpha: 1.0)

class ViMoJoController: UIViewController,
ViMoJoInterface {

    let tracker = ViMoJoTracker()
    var forcePortrait = false

    override func viewDidLoad() {
        print("View did load in \n \(self)")
        self.prefersStatusBarHidden
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(ViMoJoController.hideStatusBarAlways),
                                                         name: NSNotification.Name.UIDeviceOrientationDidChange,
                                                         object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("View will dissappear in \n \(self)")

        tracker.identifyMixpanel()

        tracker.startTimeInActivityEvent()

//        tracker.sendControllerGAITracker(getControllerName())
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View will dissappear in \n \(self)")

        tracker.sendTimeInActivity(getControllerName())
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func hideStatusBarAlways(){
        self.prefersStatusBarHidden
    }

    func getControllerName()->String{
        return String(describing: object_getClass(self))
    }
    
    func getTrackerObject() -> ViMoJoTracker {
        return self.tracker
    }
    
    func getController() -> UIViewController {
        return self
    }
}


//Force Portrait to iPad
extension ViMoJoController{
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            return UIInterfaceOrientationMask.portrait
        }else{
            return UIInterfaceOrientationMask.all
        }
    }
}
