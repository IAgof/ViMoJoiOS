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
import SwifterSwift

public class ViMoJoController: UIViewController,
ViMoJoInterface {

    let tracker = ViMoJoTracker()
    var forcePortrait:Bool{
        return false
    }

    var isStatusBarHidden:Bool{
        return false
    }
    
    override public var prefersStatusBarHidden: Bool{
        return isStatusBarHidden
    }
    
    override public func viewDidLoad() {
        print("View did load in \n \(self)")
        
//        NotificationCenter.default.addObserver(self,
//                                                         selector: #selector(ViMoJoController.hideStatusBarAlways),
//                                                         name: NSNotification.Name.UIDeviceOrientationDidChange,
//                                                         object: nil)        
        DPTheme.customizeNavigationBar(barColor: configuration.mainColor,
                                       textColor: configuration.plainButtonColor,
                                       fontName: configuration.fontName,
                                       fontSize: DPTheme.kDefaultNavigationBarFontSize,
                                       buttonColor: configuration.plainButtonColor)
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        print("View will dissappear in \n \(self)")

        tracker.identifyMixpanel()

        tracker.startTimeInActivityEvent()

//        tracker.sendControllerGAITracker(getControllerName())
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        print("View will dissappear in \n \(self)")

        tracker.sendTimeInActivity(getControllerName())
    }

    func getControllerName()->String{
        return String(describing: type(of: self))
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
    
    override public var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if forcePortrait{
            return UIInterfaceOrientationMask.portrait
        }else{
            return UIInterfaceOrientationMask.all
        }
    }
}
