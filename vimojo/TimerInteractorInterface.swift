//
//  TimerInteractorInterface.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 30/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation


protocol TimerInteractorDelegate {
    func updateTimer(time:String)
}

protocol TimerInteractorInterface {
    func setDelegate(delegate:TimerInteractorDelegate)
    func updateTime()
    func stop()
    func start()
}