//
//  CustomDPTheme.swift
//  testDrawingPortionsOverVideonaRangeSlider
//
//  Created by Alejandro Arjonilla Garcia on 4/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import UIKit

let fontName = "Helvetica"
let mainColor = #colorLiteral(red: 0.9490196078, green: 0.2941176471, blue: 0.3176470588, alpha: 1)
let secondColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

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
        
        DPTheme.customizeTabBar(barColor: mainColor, selectedTintColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), unselectedTintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
}

extension UIAlertController{
    func setTintColor(){
        self.view.tintColor = mainColor
    }
}
