//
//  SettingsDetailTextAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 26/10/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class SettingsDetailTextAction:SettingsActionInterface{
    var delegate: SettingsActionDelegate
    var textContent:String
    
    init(delegate:SettingsActionDelegate,
         textContent:String){
        self.delegate = delegate
        self.textContent = textContent
    }
    
    func executeSettingsAction(index:NSIndexPath) {
        guard let newDelegate = self.delegate as? SettingsActionDetailTextDelegate else{return}
        
        newDelegate.setTextToDetailView(SettingsActionDetailTextResponse(text: textContent))
    }
}