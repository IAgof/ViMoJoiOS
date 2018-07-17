//
//  ProjectDetailsPresenter.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 18/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
import VideonaProject
import CoreLocation

class ProjectDetailsPresenter: ProjectDetailsPresenterProtocol {
    
    weak private var view: ProjectDetailsViewProtocol?
    var interactor: ProjectDetailsInteractorProtocol?
    private let router: ProjectDetailsWireframeProtocol
    
    init(interface: ProjectDetailsViewProtocol,
         interactor: ProjectDetailsInteractorProtocol?,
         router: ProjectDetailsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    func loadValues(loaded: (ProjectInfoVideoModel) -> Void) {
        guard let project = interactor?.project else { return }
        loaded(ProjectInfoVideoModel(project: project))
    }
    func saveValues(title: String?, location: String?, description: String?) {
        interactor?.saveValues(title: title, location: location, description: description)
        router.dismiss()
    }
    func cancel() {
        router.dismiss()
    }
    func getLocation(location: @escaping (String) -> Void) {
        interactor?.getLocation(location: { (newLocation) in
            let geocoder = CLGeocoder()
            guard let newLocation = newLocation else {
                location("Can't update location")
                return
            }
            geocoder.reverseGeocodeLocation(newLocation, completionHandler: { (placeMark, error) in
                if let placeMark = placeMark,
                    let firstPlaceMark = placeMark.first{
                    location("\(firstPlaceMark.city.notNil),\(firstPlaceMark.country.notNil)")
                } else {
                    location("Can't update location")
                }
            })
        })
    }
    func goToSelectKindOfProject() {
        router.goToSelectKindOfProject()
    }
}
extension CLPlacemark {
    var city: String? {
        return addressDictionary?["City"] as? String
    }
}
