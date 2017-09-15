//
//  RealmVideo.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmVideo: Object {
    dynamic var uuid = ""
    dynamic var title = ""
    dynamic var position = 0
    dynamic var mediaPath = ""
    dynamic var videoURL = ""
    dynamic var clipText = ""
    dynamic var clipTextPosition = 0
    dynamic var startTime: Double = 0.0
    dynamic var stopTime: Double = 0.0

    override public class func primaryKey() -> String? {
        return "uuid"
    }
}
