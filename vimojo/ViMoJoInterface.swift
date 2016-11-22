//
//  ViMoJoInterface.swift
//  ViMoJo
//
//  Created by Alejandro Arjonilla Garcia on 28/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol ViMoJoInterface {
    func viewDidLoad()
    func viewWillAppear(_ animated: Bool) 
    func viewWillDisappear(_ animated: Bool)
    func getControllerName()->String
    func getTrackerObject() -> ViMoJoTracker
    func getController() -> UIViewController
}
