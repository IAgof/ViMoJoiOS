//
//  SettingsFTPBreakingNewsPasswordAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SettingsFTPBreakignNewsPasswordAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate

    init(delegate: SettingsActionDelegate) {
        self.delegate = delegate
    }

    func executeSettingsAction(_ index: IndexPath) {
        let title =  Utils().getStringByKeyFromSettings(SettingsConstants().ENTER_PASSWORD_FTP)

        let alertController = SettingsUtils().createAlertViewWithInputTextSecure(title,
                                                                                 message: "",
                                                                                 completion: {
                                                                                    text in
                                                                                    self.saveOnDefaults(text)
        })

        let controller = UIApplication.topViewController()
        if let settingsController = controller as? SettingsViewController {
            settingsController.present(alertController, animated: true, completion: nil)
        }
    }

    func saveOnDefaults(_ saveString: String) {
        defaults.set(saveString, forKey: SettingsConstants().SETTINGS_PASSWORD_FTP_BN)
        delegate.executeFinished()
    }
}
