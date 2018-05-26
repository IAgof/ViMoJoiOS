//
//  DrawerMenuInteractor.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/12/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

class DrawerMenuInteractor: DrawerMenuInteractorInterface {
    var delegate: DrawerMenuInteractorDelegate?

    var project: Project

    init(project: Project) {
        self.project = project
        setWatermarkStatus(project.hasWatermark)
    }

    func createNewProject() {
        CreateNewProjectUseCase().create(project: project)
    }

    func saveUserPhoto(image: UIImage) {
        let imageData = UIImageJPEGRepresentation(image, 1.0)

        UserDefaults.standard.set(imageData, forKey: SettingsConstants().SETTINGS_PHOTO_USER)

        delegate?.imageIsSave()
    }

    func removePhoto() {
        UserDefaults.standard.set(nil, forKey: SettingsConstants().SETTINGS_PHOTO_USER)
        delegate?.imageIsSave()
    }
    
    func setWatermarkStatus(_ value: Bool) {
        project.hasWatermark = value
        ProjectRealmRepository().update(item: project)
    }
}
