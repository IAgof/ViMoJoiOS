//
//  CAGradientLayer+Extension.swift
//  TabelRentPlatform
//
//  Created by Alejandro Arjonilla Garcia on 11.12.17.
//  Copyright © 2017 Tabel. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    static var blue: CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
        gradient.colors = [
            UIColor(red:0, green:0.68, blue:0.69, alpha:1).cgColor,
            UIColor(red:0.07, green:0.47, blue:0.59, alpha:1).cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 0.8, y: 0.89)
        gradient.endPoint = CGPoint(x: 0.21, y: 0.08)
        return gradient
    }
}
