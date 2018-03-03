//
//  SystemSettingsPaths.swift
//  vimojo
//
//  Created by Jesus Huerta on 14/02/2018.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

extension CheckPermission {
    func appSystemSetPermissions() {
        if let url = URL(string:UIApplicationOpenSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
