//
//  SettingsInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol SettingsInteractorInterface {
    func findSettings()->(Array<String>,Array<Array<Array<String>>>)
    func getAVResolutions()->Array<String>
    func getAVQualitys()->Array<String>
    func saveNameOnDefaults(name:String)
    func saveUserNameOnDefaults(userName:String)
    func saveEmailOnDefaults(email:String)
    func saveResolutionOnDefaults(resolution:String)
    func saveQualityOnDefaults(quality:String)
    func isValidEmail(email:String) -> Bool   
}