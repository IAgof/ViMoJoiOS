//
//  RecorderConstants.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 10/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
class RecordConstants: NSObject {
    // MARK: - ADVANCED_SECTION
    let WAIT_TITLE = "please_wait"
    let WAIT_DESCRIPTION = "dialog_processing"
    let WAIT_EXPORTING = "dialog_exporting_percentage"
}

enum VideoModeConfigurations {
    case zomm
    case iso
    case exposure
    case whiteBalance
    case focus
}
