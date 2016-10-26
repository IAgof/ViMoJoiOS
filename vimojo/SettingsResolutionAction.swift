//
//  SaveResolutionAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SettingsResolutionAction: SettingsActionInterface {
    let defaults = NSUserDefaults.standardUserDefaults()
    var delegate: SettingsActionDelegate
    
    init(delegate:SettingsActionDelegate){
        self.delegate = delegate
    }
    
    func executeSettingsAction(index:NSIndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().RESOLUTION)
        
        let options = AVResolutionParse().resolutionsToView()
        let alertController = SettingsUtils().createActionSheetWithOptions(title,
                                                                           options: options,
                                                                           completion: {
                                                                            response in
                                                                            self.saveResolutionOnDefaults(response)
        })
        
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = settingsController.settingsTableView.cellForRowAtIndexPath(index)
            }
            settingsController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func saveResolutionOnDefaults(saveString:String){ 
        let resolutionToSave = AVResolutionParse().parseResolutionsToInteractor(saveString)
        defaults.setObject(resolutionToSave, forKey: SettingsConstants().SETTINGS_RESOLUTION)
        
        delegate.executeFinished()
    }
}