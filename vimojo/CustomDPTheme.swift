//
//  CustomDPTheme.swift
//  testDrawingPortionsOverVideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 4/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import UIKit

class CustomDPTheme {
    func configureTheme(){  
        DPTheme.setupTheme(
            maincolor: mainColor,
            secondaryColor: secondColor,
            fontName: fontName,
            lightStatusBar: false)
        
        if let sliderImage = UIImage(named: "common_icon_seek_bar_normal"){
            DPTheme.customizeSliderThumbImage(sliderThumbImage: sliderImage)
        }
        
        if let sliderImageHighlighted = UIImage(named: "common_icon_seek_bar_pressed"){
            DPTheme.customizeSliderThumbImageHighlighted(sliderThumbImage: sliderImageHighlighted)
        }
        
        DPTheme.customizeTabBar(barColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1), textColor: mainColor)
    }
}

extension UIAlertController{
    func setTintColor(){
        self.view.tintColor = mainColor
    }
}
