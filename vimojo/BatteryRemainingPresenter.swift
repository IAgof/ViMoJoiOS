//
//  BatteryRemainingPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 7/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

public class BatteryRemainingPresenter:BatteryRemainingPresenterInterface,BatteryRemainingInteractorDelegate{
    //MARK : VIPER
    var delegate:BatteryRemainingPresenterDelegate
    var interactor:BatteryRemainingInteractorInterface?
    
    init(controller:BatteryRemainingView){
        delegate = controller
        interactor = BatteryRemainingInteractor(presenter: self)
    }
    
    func updateBatteryLevel() {
        interactor?.getBatteryUpdateValues()
    }
    
    //Interactor Delegate
    func setPercentValue(level: Float) {
        delegate.updateBarValue(CGFloat(level))
        self.updateBatteryLevelColor(level)
    }
    
    func setRemainingTimeText(text:String) {
        delegate.updateTextTimeLeft(text)
    }
    
    //MARK: - Inner function
    func updateBatteryLevelColor(level:Float){
        var color = UIColor.redColor()
        
        switch level {
        case 0...20:
            color = UIColor.redColor()
            break
        case 21...45:
            color = UIColor.yellowColor()
            break
        case 45...100:
            color = UIColor.greenColor()
            break            
        default:
            color = UIColor.redColor()
            break
        }
        
        delegate.updateBarColor(color)
    }
}