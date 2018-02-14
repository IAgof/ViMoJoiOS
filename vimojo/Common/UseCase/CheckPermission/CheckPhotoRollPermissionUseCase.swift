//
//  CheckPhotoRollPermissionUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import Photos
public class CheckPhotoRollPermissionUseCase: CheckPermission {
    public func askIfNeeded() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .restricted, .denied, .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .restricted, .denied, .notDetermined:
                    self.appSystemSetPermissions()
                default:
                    self.appSystemSetPermissions()
                }
            }
        default:
            break
        }
    }
}
