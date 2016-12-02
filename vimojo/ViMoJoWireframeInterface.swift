//
//  ViMoJoWireframeInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 1/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

protocol ViMoJoWireframeInterface {
    var rootWireframe : RootWireframe?{get set}
    var viewController : ViMoJoController?{get set}
    var presenter : ViMoJoPresenterInterface?{get set}
    
    var prevController:UIViewController?{get set}
    
    func presentInterfaceFromWindow(_ window: UIWindow) 
    func presentInterfaceFromViewController(_ prevController:UIViewController)
    func goPrevController()
}
