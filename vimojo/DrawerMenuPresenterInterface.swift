//
//  DrawerMenuPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol DrawerMenuPresenterInterface {
    func didSelectAtIndexPath(indexPath:IndexPath)
    func exitPushed()
    func imagePushed()
    func takePhoto()
    func takeFromGallery()
    func removePhoto()
    
    func saveImageSelected(image:UIImage)
}

protocol DrawerMenuPresenterDelegate {
    func closeDrawer()
    func layoutDrawerControllerView()
    func presentAlertWithOptions()
    
    func presentPickerController(withOptionSelected option:TakePhotoFromOptions)
    func updateProfileCell()
}
