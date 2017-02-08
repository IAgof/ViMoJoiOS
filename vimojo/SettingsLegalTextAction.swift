//
//  SettingsLegalTextAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsLegalTextAction:SettingsActionInterface{
    var delegate: SettingsActionDelegate
    var legalUrlString:String
    
    init(delegate:SettingsActionDelegate,
         legalUrlString:String){
        self.delegate = delegate
        self.legalUrlString = legalUrlString
    }
    
    func executeSettingsAction(_ index:IndexPath) {
        if let url = URL(string:legalUrlString){
            if (UIApplication.shared.canOpenURL(url)) {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
