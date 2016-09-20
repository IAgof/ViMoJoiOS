//
//  EditingRoomPresenterInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 19/7/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol EditingRoomPresenterInterface{
    
    func viewDidLoad()
    
    func viewWillDisappear()
    
    func viewWillAppear()
    
    func pushSettings()
    
    func pushBack()
    
    func pushEditor()
    
    func pushMusic()
    
    func pushShare()
}
