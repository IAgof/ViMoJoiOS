//
//  RealmProject.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import RealmSwift

class IntObject: Object {
    dynamic var value: Int = 0
}
public class RealmProject: Object {
    dynamic var uuid = ""
    // Project Info
    dynamic var title = ""
    dynamic var date: Date = Date()
    dynamic var author: String = ""
    dynamic var location: String = ""
    dynamic var projectDescription: String = ""
//    let productTypes: List<IntObject> = List<IntObject>()
    // Project Info end
    dynamic var projectPath = ""
    dynamic var quality = ""
    dynamic var resolution = ""
    dynamic var frameRate: Int = 30
    dynamic var musicTitle: String = ""
    dynamic var musicVolume: Double = 0.5
    var videos = List<RealmVideo>()
    dynamic var modificationDate: Date?
    dynamic var exportedDate: Date?
    dynamic var exportedPath: String?
    var voiceOver = List<RealmAudio>()
        dynamic var isVoiceOverSet: Bool = false
    dynamic var voiceOverAudioLevel: Float = 0
    dynamic var projectOutputAudioLevel: Float = 1
    dynamic var transitionTime: Double = 0

    dynamic var filterName: String = ""
    dynamic var brightnessLevel: NSNumber = 0
    dynamic var contrastLevel: NSNumber = 0
    dynamic var saturationLevel: NSNumber = 0
    dynamic var exposureLevel: NSNumber = 0
    dynamic var hasWatermark: Bool = false

    override public class func primaryKey() -> String? {
        return "uuid"
    }
}
