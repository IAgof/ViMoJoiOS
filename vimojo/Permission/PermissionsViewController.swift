//
//  PermissionsViewController.swift
//  vimojo
//
//  Created Jesus Huerta on 15/03/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
import Permission

class PermissionsViewController: UIViewController {
        
    var backgroundImage: UIImageView = UIImageView()
    internal var router: PermissionsWireframeProtocol?
    private var microphonePermission: Permission! = .microphone
    private var cameraPermission: Permission! = .camera
    private var photoGalleryPermission: Permission! = .photos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        backgroundImage.image = appLaunchImage()
        askForCameraPermissionIfNeeded()
        askForMicrophonePermissionIfNeeded()
        askForGalleryPermissionIfNeeded()
    }
    func updateStatus() {
        let permissionSet = PermissionSet(.camera, .microphone, .photos)
        switch permissionSet.status {
        case .authorized:
            router?.goToRecorderScreen()
        case .denied, .disabled:
            if microphonePermission.status != .authorized {
                self.askForMicrophonePermissionIfNeeded()
            } else if cameraPermission.status != .authorized {
                self.askForCameraPermissionIfNeeded()
            } else if photoGalleryPermission.status != .authorized {
                self.askForGalleryPermissionIfNeeded()
            }
        case .notDetermined:
            break
        }
    }
    func askForCameraPermissionIfNeeded() {
        cameraPermission.request { status in
            self.updateStatus()
        }
    }
    
    func askForMicrophonePermissionIfNeeded() {
        microphonePermission.request { status in
            self.updateStatus()
        }
    }
    
    func askForGalleryPermissionIfNeeded() {
        photoGalleryPermission.request { status in
            self.updateStatus()
        }
    }
    func appLaunchImage() -> UIImage? {
        let allPngImageNames = Bundle.main.paths(forResourcesOfType: "png", inDirectory: nil)
        
        for imageName in allPngImageNames {
            guard imageName.contains("LaunchImage") else { continue }
            
            guard let image = UIImage(named: imageName) else { continue }
            
            // if the image has the same scale AND dimensions as the current device's screen...
            
            if (image.scale == UIScreen.main.scale) && (image.size.equalTo(UIScreen.main.bounds.size)) {
                return image
            }
        }
        
        return nil
    }

}
