//
//  UserProtocols.swift
//  LoginProject
//
//  Created Alejandro Arjonilla Garcia on 02.05.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol UserWireframeProtocol: class {
    func navigateToHandoff()
}
//MARK: Presenter -
protocol UserPresenterProtocol: class {
    func navigate()
}

//MARK: Interactor -
protocol UserInteractorProtocol: class {

  var presenter: UserPresenterProtocol?  { get set }
}

//MARK: View -
protocol UserViewProtocol: class {

  var presenter: UserPresenterProtocol?  { get set }
}
