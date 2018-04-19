//
//  Double+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 19.04.18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

extension Double {
    var formattedTime: String {
        var lessThanTen: (Int) -> String {
            return { ($0 < 10 ? ("0" + $0.string) : $0.string) }
        }
        var formattedTime = "00:00:00"
        if self > 0 {
            let hours = Int(self / 3600)
            let minutes = Int(truncatingRemainder(dividingBy: 3600) / 60)
            let seconds = Int(truncatingRemainder(dividingBy: 3600))
            formattedTime = "\(hours):\(lessThanTen(minutes)):\(lessThanTen(seconds))"
        }
        return formattedTime
    }
}

