//
//  CheckCameraPermissionUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class CheckCameraPermissionUseCase:CheckPermission{
    public func askIfNeeded() {
        let authorizationState = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authorizationState {
        case .notDetermined,
             .restricted,
             .denied:
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (didAllow) in
                if !didAllow{
                    self.askIfNeeded()
                }
            })
        default:
            break
        }
    }
    
}
