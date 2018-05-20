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
		case removeWatermark = 2
        case options = 3
        case shop = 4
        case mojokit = 5
        case recordTutorial = 6
        case editionTutorial = 7
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
				case .removeWatermark:
					self.switchWatermark()
					break;
                case .options:
                    wireframe?.presentSettings()
                    break
                case .shop:
                    self.switchWatermark()
                    break
                case .mojokit:
                    wireframe?.goToMojoKit()
                    break
                case .recordTutorial:
                    wireframe?.presentRecordTutorial()
                    break
                case .editionTutorial:
                    wireframe?.presentEditTutorial()
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
        let watermarkProduct = PurchaseProduct.removeWatermark
        if watermarkProduct.isPurchased {
            PurchaseProduct.setEnabled(state: !watermarkProduct.isEnabled,
                                       product: watermarkProduct)
            delegate?.watermarkIsEnabled = watermarkProduct.isEnabled
            interactor?.setWatermarkStatus(watermarkProduct.isEnabled)
        } else {
            wireframe?.presentPurchaseScreen()
        }
    }
    func loadWatermarkState(state: (Bool) -> Void) {
        state(interactor?.project.hasWatermark ?? false)
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
