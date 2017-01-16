//
//  RealmProject.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmProject:Object{
    dynamic var uuid = ""
    dynamic var title = ""
    dynamic var projectPath = ""
    dynamic var quality = ""
    dynamic var resolution = ""
    dynamic var frameRate:Int = 30
    dynamic var musicTitle:String = ""
    dynamic var musicVolume:Double = 0.5
    var videos = List<RealmVideo>()
    dynamic var modificationDate: NSDate? = nil
    dynamic var exportedDate: NSDate? = nil
    dynamic var exportedPath: String? = nil
    var voiceOver = List<RealmAudio>()
        dynamic var isVoiceOverSet: Bool = false
    dynamic var voiceOverAudioLevel:Float = 0
    dynamic var projectOutputAudioLevel:Float = 1
    dynamic var transitionTime:Double = 0
    
    override public class func primaryKey() -> String? {
        return "uuid"
    }
}
