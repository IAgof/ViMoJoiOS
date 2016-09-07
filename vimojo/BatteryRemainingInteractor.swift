//
//  BatteryRemainingInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

class BatteryRemainingInteractor: BatteryRemainingInteractorInterface {
    //MARK : VIPER
    var delegate:BatteryRemainingInteractorDelegate?
    
    init(presenter:BatteryRemainingPresenter){
        UIDevice.currentDevice().batteryMonitoringEnabled = true

        delegate = presenter
        setUpBatteryListener()
    }
    
    func getBatteryUpdateValues() {
        getBatteryLevel()
        getEstimatedBatteryTime()
    }
    
    func getBatteryLevel(){
        let batteryLevel = (UIDevice.currentDevice().batteryLevel) * 100
        delegate?.setPercentValue(batteryLevel)
    }
    
    func getEstimatedBatteryTime(){
        let batteryLevel = (UIDevice.currentDevice().batteryLevel)
        
        let estimatedTimeCapturingVideoForFullBattery:Float = 4.0
        
        let timeLeft = batteryLevel*estimatedTimeCapturingVideoForFullBattery*3600
        
        let text = hourToString(Double(timeLeft))
        
        delegate?.setRemainingTimeText(text)
    }
    
    func hourToString(time:Double) -> String {
        let hours = Int(floor(time/3600))
        let mins = Int(floor(time % 3600) / 60)
        
        return String(format:"%02dh. %02dm.", hours,mins)
    }
    
    func setUpBatteryListener(){
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(batteryLevelChanged),
            name: UIDeviceBatteryLevelDidChangeNotification,
            object: nil)
    }
    
    @objc func batteryLevelChanged(){
        self.getBatteryUpdateValues()
    }
}