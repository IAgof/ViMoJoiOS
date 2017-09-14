//
//  DrawerMenuInteractorInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol DrawerMenuInteractorInterface {
    func createNewProject()
    func saveUserPhoto(image: UIImage)
    func removePhoto()
}

protocol DrawerMenuInteractorDelegate {
    func imageIsSave()
}
