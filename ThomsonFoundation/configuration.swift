//
//  configuration.swift
//  vimojo
//
//  Created by Jesus Huerta on 08/08/2017.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

var configuration:ConfigurationProtocol = ThomsonFoundationConfiguration()

final class ThomsonFoundationConfiguration: ConfigurationProtocol {
	internal var fontName: String
	internal var mainColor: UIColor
	internal var plainButtonColor: UIColor
	internal var secondColor: UIColor
	internal var secondColorWithOpacity: UIColor
	internal var VOICE_OVER_FEATURE: Bool
	internal var FTP_FEATURE: Bool
	
	init() {
		fontName = "Helvetica"
		mainColor = #colorLiteral(red: 0.03529411765, green: 0.6392156863, blue: 0.8941176471, alpha: 1)
		plainButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		secondColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
		secondColorWithOpacity = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
		VOICE_OVER_FEATURE = true
		FTP_FEATURE = true
	}
}
