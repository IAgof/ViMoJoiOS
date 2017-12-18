//
//  DrawerMenuTableViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 1/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

extension SettingsConstants {
    private static let watermarkSwitchKey = "watermarkSwitchKey"
    private static let watermarkWasBoughtKey = "watermarkWasBoughtKey"
    static var watermarkIsEnabled: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsConstants.watermarkSwitchKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: SettingsConstants.watermarkSwitchKey)
        }
    }
    static var watermarkWasBought: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: SettingsConstants.watermarkWasBoughtKey)
        }
        get {
            return UserDefaults.standard.bool(forKey: SettingsConstants.watermarkWasBoughtKey)
        }
    }
}
class DrawerMenuTableViewController: UITableViewController {
    var eventHandler: DrawerMenuPresenterInterface?

    @IBOutlet weak var watermarkSwitch: UISwitch!
    @IBOutlet weak var userContentView: UIView!
    
    var watermarkIsEnabled: Bool = SettingsConstants.watermarkIsEnabled {
        didSet {
            watermarkSwitch.setOn(SettingsConstants.watermarkIsEnabled, animated: false)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        userContentView.backgroundColor = configuration.mainColor
        watermarkIsEnabled = SettingsConstants.watermarkIsEnabled
    }

    override func viewWillAppear(_ animated: Bool) {
            print("View will appear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func watermarkPushed(_ sender: Any) {
        watermarkSwitch.setOn(SettingsConstants.watermarkIsEnabled, animated: false)
        eventHandler?.switchWatermark()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.didSelectAtIndexPath(indexPath: indexPath)
    }

    @IBAction func exitButtonPushed(_ sender: Any) {
        eventHandler?.exitPushed()
    }

    @IBAction func imagePushed(_ sender: Any) {
        eventHandler?.imagePushed()
    }
}

extension DrawerMenuTableViewController: DrawerMenuPresenterDelegate {
    func closeDrawer() {
        if let parentController = (self.parent as? KYDrawerController) {
           parentController.setDrawerState(.closed, animated: true)
        }
    }

    func layoutDrawerControllerView() {
        if let parentController = parent as? KYDrawerController {
            parentController.mainViewController.viewWillAppear(true)
        }
    }

    func presentAlertWithOptions() {
        let drawerConstants = DrawerConstants()

        let alertController = UIAlertController(title: drawerConstants.ACTIVITY_DRAWER_ALERT_TITLE,
                                                message: drawerConstants.ACTIVITY_DRAWER_ALERT_MESSAGE,
                                                preferredStyle: .actionSheet)
        alertController.setTintColor()

        let takePhotoAction = UIAlertAction(title: drawerConstants.ACTIVITY_DRAWER_ALERT_OPTION_TAKE_PHOTO,
                                            style: .default,
                                            handler: {_ -> Void in
                                                self.eventHandler?.takePhoto()
        })

        let takeFromGalleryAction = UIAlertAction(title: drawerConstants.ACTIVITY_DRAWER_ALERT_OPTION_TAKE_FROM_GALLERY,
                                            style: .default,
                                            handler: {_ -> Void in
                                                self.eventHandler?.takeFromGallery()
        })

        let removeAction = UIAlertAction(title: drawerConstants.ACTIVITY_DRAWER_ALERT_OPTION_REMOVE,
                                                  style: .destructive,
                                                  handler: {_ -> Void in
                                                    self.eventHandler?.removePhoto()
        })

        alertController.addAction(removeAction)
        alertController.addAction(takeFromGalleryAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(.init(title: drawerConstants.ACTIVITY_DRAWER_ALERT_OPTION_CANCEL,
                                        style: .cancel, handler: nil))

        let controller = UIApplication.topViewController()
        controller?.present(alertController, animated: true, completion: nil)
    }

    func presentPickerController(withOptionSelected option: TakePhotoFromOptions) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self

        if option == .camera {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }

        present(picker, animated: true)
    }
}

extension DrawerMenuTableViewController:KYDrawerControllerDelegate {
    func viewWillAppear() {
        closeDrawer()
        updateProfileCell()
    }

    func updateProfileCell() {
        if let cell = self.tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? DrawerProfileTableViewCell {
            cell.configureView()
        }
    }
}

extension DrawerMenuTableViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage

        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        eventHandler?.saveImageSelected(image: newImage)

        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
