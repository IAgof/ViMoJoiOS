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

    func execute(completion:@escaping (Bool) -> Void) {
        let title = ProjectListConstants.REMOVE_PROJECT_ALERT_TITLE
        let removeString = ProjectListConstants.REMOVE_PROJECT_ALERT_YES_BUTTON

        let cancelString = ProjectListConstants.REMOVE_PROJECT_ALERT_NO_BUTTON

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alertController.setTintColor()

        let removeAction = UIAlertAction(title: removeString, style: .default, handler: {_ -> Void in
            completion(true)
        })

        let cancelAction = UIAlertAction(title: cancelString, style: .default, handler: {_ -> Void in
            completion(false)
        })

        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)

        let controller = UIApplication.topViewController()
        controller?.present(alertController, animated: true, completion: nil)
    }
}
