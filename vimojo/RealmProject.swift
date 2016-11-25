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
    dynamic var title = ""
    dynamic var projectPath = ""
    dynamic var quality = ""
    dynamic var resolution = ""
    dynamic var frameRate:Int = 30
    dynamic var musicTitle:String = ""
    dynamic var musicVolume:Double = 0.5
    let videos = List<RealmVideo>()
}
