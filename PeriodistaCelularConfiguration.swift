//
//  PeriodistaCelularConfiguration.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 2/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

var configuration: ConfigurationProtocol = PeriodistaCelularConfiguration()

final class PeriodistaCelularConfiguration: ConfigurationProtocol {
    internal var fontName: String
    internal var mainColor: UIColor
    internal var plainButtonColor: UIColor
    internal var secondColor: UIColor
    internal var secondColorWithOpacity: UIColor
    internal var VOICE_OVER_FEATURE: Bool
    internal var FTP_FEATURE: Bool
    internal var WATERMARK_FEATURE: Bool

    init() {
        fontName = "Helvetica"
        mainColor = #colorLiteral(red: 0.4941176471, green: 0.8352941176, blue: 0.8039215686, alpha: 1)
        plainButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        secondColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        secondColorWithOpacity = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
        VOICE_OVER_FEATURE = false
        FTP_FEATURE = false
        WATERMARK_FEATURE = false
    }
}
