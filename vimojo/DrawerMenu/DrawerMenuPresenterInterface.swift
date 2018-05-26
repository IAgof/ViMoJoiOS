//
//  DrawerMenuPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

protocol DrawerMenuPresenterInterface {
    func didSelectAtIndexPath(indexPath: IndexPath)
    func exitPushed()
    func imagePushed()
    func takePhoto()
    func takeFromGallery()
    func removePhoto()
    func switchWatermark()
    func saveImageSelected(image: UIImage)
    func loadWatermarkState(state: (Bool) -> Void)
}

protocol DrawerMenuPresenterDelegate {
    func closeDrawer()
    func layoutDrawerControllerView()
    func presentAlertWithOptions()

    func presentPickerController(withOptionSelected option: TakePhotoFromOptions)
    func updateProfileCell()
    var watermarkIsEnabled: Bool { get set }
}
