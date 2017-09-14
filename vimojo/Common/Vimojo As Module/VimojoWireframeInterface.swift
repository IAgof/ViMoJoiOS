//
//  VimojoWireframeInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

protocol VimojoWireframeInterface {
    associatedtype viewControllerType
    associatedtype presenterType

    var viewControllerIdentifier: String {get set}
    var storyboardName: String {get set}
    func presentInterfaceFromWindow(_ window: UIWindow)
    func presentInterfaceFromViewController(_ prevController: UIViewController)
    func viewControllerFromStoryboard() -> viewControllerType
    func getStoryboard() -> UIStoryboard
    func goPrevController()
}
