//
//  SettingsWatermarkAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 4/9/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SettingsWatermarkAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate
    var project:Project
    
    init(delegate:SettingsActionDelegate,
         project:Project){
        self.delegate = delegate
        self.project = project
    }
    
    func executeSettingsAction(_ index:IndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().WATERMARK_TITLE)
        
        let options = ["watermarkEnabled".localized(.settings), "watermarkDisabled".localized(.settings)]
        let alertController = SettingsUtils().createActionSheetWithOptions(title,
                                                                           options: options,
                                                                           completion: {
                                                                            response in
                                                                            self.saveOnProject(response)
        })
        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = settingsController.settingsTableView.cellForRow(at: index)
            }
            settingsController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveOnProject(_ saveString:String){
        project.hasWatermark = saveString == "watermarkEnabled".localized(.settings)

        ProjectRealmRepository().update(item: project)

        delegate.executeFinished()
    }
}
