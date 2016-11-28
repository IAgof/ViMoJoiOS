//
//  CheckMicPermissionUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import AVFoundation

public class CheckMicPermissionUseCase:CheckPermission{
    let avSession = AVAudioSession.sharedInstance()
    public func askIfNeeded() {
        switch (avSession.recordPermission()) {
        case AVAudioSessionRecordPermission.denied ,AVAudioSessionRecordPermission.undetermined:
            avSession.requestRecordPermission({
                granted in
                if !granted{
                    self.askIfNeeded()
                }
            })
            
            break;
        default:
            break;
        }
    }
}
