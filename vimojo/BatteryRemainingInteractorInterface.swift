//
//  BatteryRemainingInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol BatteryRemainingInteractorInterface{
    func getBatteryUpdateValues()
}

protocol BatteryRemainingInteractorDelegate{
    func setPercentValue(level:Float)
    func setRemainingTimeText(text:String)
}