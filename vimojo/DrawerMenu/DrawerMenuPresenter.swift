//
//  DrawerMenuPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class DrawerMenuPresenter: DrawerMenuPresenterInterface {

    var delegate: DrawerMenuPresenterDelegate?
    var wireframe: DrawerMenuWireframe?
    var interactor: DrawerMenuInteractorInterface?

    enum cellType: Int {
        case projects = 0
        case newProject = 1
        case options = 2
    }
    let optionsSection = 1

    func didSelectAtIndexPath(indexPath: IndexPath) {
        if indexPath.section == optionsSection {
            if let row = cellType(rawValue: indexPath.item) {
                switch row {
                case .projects:
                    wireframe?.presentProjectsSelector()
                    break
                case .newProject:
                    interactor?.createNewProject()
                    wireframe?.presentGoToRecordOrGalleryWireframe()
                    break
                case .options:
                    wireframe?.presentSettings()
                    break
                }
            }
        }
    }

    func exitPushed() {
        delegate?.closeDrawer()
    }

    func imagePushed() {
        delegate?.presentAlertWithOptions()
    }

    func takePhoto() {
        delegate?.presentPickerController(withOptionSelected: .camera)
    }

    func takeFromGallery() {
        delegate?.presentPickerController(withOptionSelected: .gallery)
    }

    func saveImageSelected(image: UIImage) {
        interactor?.saveUserPhoto(image: image)
    }

    func removePhoto() {
        interactor?.removePhoto()
    }
    func switchWatermark() {
        let product = PurchaseProduct.removeWatermark
        if product.isPurchased {
            PurchaseProduct.setEnabled(state: !product.isEnabled,
                                       product: product)
            delegate?.watermarkIsEnabled = product.isEnabled
        } else {
            wireframe?.presentPurchaseScreen()
        }
    }
}

extension DrawerMenuPresenter:DrawerMenuInteractorDelegate {
    func imageIsSave() {
        delegate?.updateProfileCell()
    }
}
extension Bool {
    mutating func toogle() {
        self = !self
    }
}
