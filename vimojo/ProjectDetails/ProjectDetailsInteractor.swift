//
//  ProjectDetailsInteractor.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
import VideonaProject
import CoreLocation

class ProjectDetailsInteractor: ProjectDetailsInteractorProtocol {

    weak var presenter: ProjectDetailsPresenterProtocol?
    var project: Project
    var locationManager: CLLocationManager
    
    init(project: Project) {
        self.project = project
        locationManager = CLLocationManager()
    }
    func saveValues(title: String?, location: String?, description: String?) {
        project.projectInfo.title = title.notNil
        project.projectInfo.location = location.notNil
        project.projectInfo.description = description.notNil
        ProjectRealmRepository().update(item: project)
    }
    func getLocation(location: (CLLocation?) -> Void) {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            location(locationManager.location)
        } else {
            if let url = URL(string:UIApplicationOpenSettingsURLString),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}

extension Optional where Wrapped == String {
    var notNil: String {
        return self ?? ""
    }
}
