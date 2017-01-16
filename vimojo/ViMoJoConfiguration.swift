//
//  ViMoJoConfiguration.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

var configuration:ConfigurationProtocol = ViMoJoConfiguration()

final class ViMoJoConfiguration: ConfigurationProtocol {
    internal var fontName: String
    internal var mainColor: UIColor
    internal var mainColorWithOpacity: UIColor
    internal var secondColor: UIColor
    internal var secondColorWithOpacity: UIColor
    internal var VOICE_OVER_FEATURE: Bool
    internal var FTP_FEATURE: Bool
    
    init() {
        fontName = "Helvetica"
        mainColor = #colorLiteral(red: 0.9490196078, green: 0.2941176471, blue: 0.3176470588, alpha: 1)
        mainColorWithOpacity = #colorLiteral(red: 0.9490196078, green: 0.2941176471, blue: 0.3176470588, alpha: 0.5)
        secondColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        secondColorWithOpacity = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        VOICE_OVER_FEATURE = false
        FTP_FEATURE = false
    }
}
