//
//  RecordingCameraConfigurationPresenter.swift
//  vimojo
//
//  Created Jesus Huerta on 19/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
import AVFoundation

class RecordingCameraConfigurationPresenter: RecordingCameraConfigurationPresenterProtocol, RecordingCameraConfigurationInteractorOutputProtocol {

    weak private var view: RecordingCameraConfigurationViewProtocol?
    var interactor: RecordingCameraConfigurationInteractorInputProtocol?
    private let router: RecordingCameraConfigurationWireframeProtocol
    private var cameraSelected: CameraPosition = .back {
        didSet {
            updateValues(cameraSelected: cameraSelected)
            view?.reloadCamera()
        }
    }
    
    init(interface: RecordingCameraConfigurationViewProtocol, interactor: RecordingCameraConfigurationInteractorInputProtocol?, router: RecordingCameraConfigurationWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        cameraSelected = .back
        updateValues(cameraSelected: cameraSelected)
    }
    func actionPush(with action: RecordingCameraActions) {
        interactor?.actionPush(with: action)
    }
    func cameraSelected(cameraIndex: Int) {
        cameraSelected = cameraIndex == 0 ? .back: .front
    }
    private func updateValues(cameraSelected: CameraPosition) {
        interactor?.loadValues(with: cameraSelected) {
            view?.setDefaultValues(loadedValues: $0)
        }
    }
}
