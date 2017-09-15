//
//  FlashInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 24/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

class FlashInteractor {

    let FLASH_ON = true
    let FLASH_OFF = false

    let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

    func switchFlashState() -> Bool {
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == AVCaptureTorchMode.on) {

                    device?.torchMode = AVCaptureTorchMode.off
                    return FLASH_OFF
                } else {

                    try device?.setTorchModeOnWithLevel(1.0)
                    return FLASH_ON
                }
            } catch {
                print(error)
                return FLASH_OFF
            }
        } else {
            return FLASH_OFF
        }
    }

    func isFlashTurnOn() -> Bool {
        return device!.torchMode == .on
    }

    func turnOffWhenViewWillDissappear() {
        if self.isFlashTurnOn() {
            self.switchFlashState()
        }
    }
}
