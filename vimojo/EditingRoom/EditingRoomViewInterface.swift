//
//  EditingRoomViewInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol EditingRoomViewInterface:ViMoJoInterface{
    func deselectAllButtons()
    func selectEditorButton()
    func selectMusicButton()
    func selectShareButton()
    func createAlertWaitToExport()
    func dissmissAlertWaitToExport(completion:()->Void)

}
