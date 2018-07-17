//
//  UIButton+Extension.swift
//  LoginProject
//
//  Created by Alejandro Arjonilla Garcia on 02.05.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setLoginAppearence() {
        snp.makeConstraints{( $0.height.equalTo(45) )}
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.white.cgColor
        titleLabel?.font =  UIFont(name: "Helvetica", size: 23)
        setTitleColor(.white, for: .normal)
    }
}
