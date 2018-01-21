//
//  RecordingCameraConfigurationProtocols.swift
//  vimojo
//
//  Created Jesus Huerta on 19/01/2018.
//  Copyright © 2018 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

enum RecordingCameraActions {
    enum Camera: Int {
        case cameraPro = 0
        case cameraBasic
    }
 
    case camera(Camera)
    case resolution(Resolution)
    case fps(FrameRate)
    case mbps(BitRate)
}

//MARK: Wireframe -
protocol RecordingCameraConfigurationWireframeProtocol: class {

}
//MARK: Presenter -
protocol RecordingCameraConfigurationPresenterProtocol: class {

    var interactor: RecordingCameraConfigurationInteractorInputProtocol? { get set }
    
    func viewDidLoad()
    func actionPush(with action: RecordingCameraActions)
}

//MARK: Interactor -
protocol RecordingCameraConfigurationInteractorOutputProtocol: class {

    /* Interactor -> Presenter */
}

protocol RecordingCameraConfigurationInteractorInputProtocol: class {

    var presenter: RecordingCameraConfigurationInteractorOutputProtocol?  { get set }

    func loadValues(completion: (RecordingCameraValues) -> Void )
    func actionPush(with action: RecordingCameraActions)

    /* Presenter -> Interactor */
}

//MARK: View -
protocol RecordingCameraConfigurationViewProtocol: class {

    var presenter: RecordingCameraConfigurationPresenterProtocol?  { get set }

	func setDefaultValues(loadedValues: RecordingCameraValues)

    /* Presenter -> ViewController */
}
