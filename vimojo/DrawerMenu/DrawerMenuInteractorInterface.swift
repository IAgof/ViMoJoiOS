//
//  DrawerMenuInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

protocol DrawerMenuInteractorInterface {
    func createNewProject()
    func saveUserPhoto(image: UIImage)
    func removePhoto()
    func setWatermarkStatus(_ value: Bool)
    var project: Project { get set }
}

protocol DrawerMenuInteractorDelegate {
    func imageIsSave()
}
