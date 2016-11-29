//
//  RemoveProjectOnProjectListAction.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class RemoveProjectOnProjectListAction {
    
    func execute(completion:@escaping (Bool)->Void){
        let title = "Remove title"
        let removeString = "Yes"
        
        let cancelString = Utils().getStringByKeyFromSettings(SettingsConstants().CANCEL_SETTINGS_CAMERA)
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        let removeAction = UIAlertAction(title: removeString, style: .default, handler: {alert -> Void in
            completion(true)
        })
        
        let cancelAction = UIAlertAction(title: cancelString, style: .default, handler: {alert -> Void in
            completion(false)
        })
        
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        
        let controller = UIApplication.topViewController()
        controller?.present(alertController, animated: true, completion: nil)
    }
}
