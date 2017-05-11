//
//  EditingRoomItemController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 14/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class EditingRoomItemController: ViMoJoController {

    @IBAction func showSideDrawer(_ sender: AnyObject) {
        print("Show side drawer")
        var parent = self.parent
        while parent != nil {
            if let drawer = parent as? KYDrawerController{
                drawer.setDrawerState(.opened, animated: true)
            }
            parent = parent?.parent
        }
    }
}
