//
//  SettingsTransition.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 2/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

enum TransitionTime:Double {
    case noTransition = 0
    case oneSecond = 1
    case halfSecond = 0.5
    case quarterSecond = 0.25
}

class SettingsTransition {
    let defaults = UserDefaults.standard
    var transitionTime:Double = 0
    
    init(){
        transitionTime = defaults.double(forKey: SettingsConstants().TRANSITION)
    }
    
    func save(value:String){
        var valueToSave:Double = 0
        
        switch value {
        case Utils().getStringByKeyFromSettings(SettingsConstants().NO_TRANSITION):
            valueToSave = 0
        case Utils().getStringByKeyFromSettings(SettingsConstants().ONE_SECOND_TRANSITION):
            valueToSave = 1
        case Utils().getStringByKeyFromSettings(SettingsConstants().HALF_SECOND_TRANSITION):
            valueToSave = 0.5
        case Utils().getStringByKeyFromSettings(SettingsConstants().QUARTER_SECOND_TRANSITION):
            valueToSave = 0.25
        default:
            valueToSave = 0
        }
        
        transitionTime = valueToSave
        
        defaults.set(valueToSave, forKey: SettingsConstants().TRANSITION)
    }
    
    func getTransitionToView()->String{
        if let time = TransitionTime(rawValue: transitionTime){
            
            switch  time{
            case .noTransition:
                return Utils().getStringByKeyFromSettings(SettingsConstants().NO_TRANSITION)
            case .oneSecond:
                return Utils().getStringByKeyFromSettings(SettingsConstants().ONE_SECOND_TRANSITION)
            case .halfSecond:
                return Utils().getStringByKeyFromSettings(SettingsConstants().HALF_SECOND_TRANSITION)
            case .quarterSecond:
                return Utils().getStringByKeyFromSettings(SettingsConstants().QUARTER_SECOND_TRANSITION)
            }
        }else{
            return Utils().getStringByKeyFromSettings(SettingsConstants().NO_TRANSITION)
        }
    }
    
    func getAllTransitionsToView()->[String]{
        var transitions:[String] = []
        
        transitions.append(Utils().getStringByKeyFromSettings(SettingsConstants().NO_TRANSITION))
        transitions.append(Utils().getStringByKeyFromSettings(SettingsConstants().ONE_SECOND_TRANSITION))
        transitions.append(Utils().getStringByKeyFromSettings(SettingsConstants().HALF_SECOND_TRANSITION))
        transitions.append(Utils().getStringByKeyFromSettings(SettingsConstants().QUARTER_SECOND_TRANSITION))
        
        return transitions
    }
}
