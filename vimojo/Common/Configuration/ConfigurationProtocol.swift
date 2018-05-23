//
//  ConfigurationProtocol.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

protocol ConfigurationProtocol {
    var fontName: String {get}
    var mainColor: UIColor {get}
    var plainButtonColor: UIColor {get}
    var secondColor: UIColor {get}
    var secondColorWithOpacity: UIColor {get}

    var VOICE_OVER_FEATURE: Bool {get}
    var FTP_FEATURE: Bool {get}
    
    var IS_WATERMARK_PURCHABLE: Bool {get}
    var IS_WATERMARK_SWITCHABLE: Bool {get}
    var IS_WATERMARK_ENABLED: Bool {get}
	var GO_TO_SHOP_ENABLED: Bool {get}
}
