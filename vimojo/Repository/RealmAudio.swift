//
//  RealmAudio.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 9/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmAudio: Object {
    
    dynamic var uuid = ""
    dynamic var title = ""
    dynamic var mediaPath = ""
    dynamic var startTime:Double = 0.0
    dynamic var stopTime:Double = 0.0
    
    override public class func primaryKey() -> String? {
        return "uuid"
    }
}
