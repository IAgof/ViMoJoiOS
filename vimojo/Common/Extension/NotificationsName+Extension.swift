//
//  NotificationsName+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 30/6/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension Notification {
    static var audioUpdate: Notification.Name {
        return Notification.Name(rawValue: "projectAudio")
    }
}
