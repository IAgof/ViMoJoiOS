//
//  SettingsNameAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class SettingsLoginAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate

    init(delegate: SettingsActionDelegate) {
        self.delegate = delegate
    }

    func executeSettingsAction(_ index: IndexPath) {
        SessionManager.shared.login { _ in
            self.delegate.executeFinished()
        }
    }
}
class SettingsLogoutAction: SettingsActionInterface {
    let defaults = UserDefaults.standard
    var delegate: SettingsActionDelegate
    
    init(delegate: SettingsActionDelegate) {
        self.delegate = delegate
    }
    
    func executeSettingsAction(_ index: IndexPath) {
        SessionManager.shared.logout()
        delegate.executeFinished()
    }
}
