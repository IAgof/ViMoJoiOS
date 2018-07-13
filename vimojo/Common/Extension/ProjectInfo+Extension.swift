//
//  ProjectInfo+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 13/7/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation
import VideonaProject

extension ProjectInfo.ProductTypes {
    var localizedValue: String {
        switch self {
        case .liveOnTape:
            return  "product_type_live_on_tape".localized(.projectDetails)
        case .bRoll:
            return  "product_type_b_roll".localized(.projectDetails)
        case .natVO:
            return  "product_type_nat_vo".localized(.projectDetails)
        case .interview:
            return  "product_type_interview".localized(.projectDetails)
        case .graphics:
            return  "product_type_graphics".localized(.projectDetails)
        case .piece:
            return  "product_type_piece".localized(.projectDetails)
        }
    }
    var multipartVal: String {
        switch self {
        case .liveOnTape:
            return  "LIVE_ON_TAPE"
        case .bRoll:
            return  "B_ROLL"
        case .natVO:
            return  "NAT_VO"
        case .interview:
            return  "INTERVIEW"
        case .graphics:
            return  "GRAPHICS"
        case .piece:
            return  "PIECE"
        }
    }
}
