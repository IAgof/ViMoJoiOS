//
//  UserProtocols.swift
//  LoginProject
//
//  Created Alejandro Arjonilla Garcia on 02.05.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//


import Foundation

//MARK: Wireframe -
protocol UserWireframeProtocol: class {
}
//MARK: Presenter -
protocol UserPresenterProtocol: class {
}

//MARK: Interactor -
protocol UserInteractorProtocol: class {

  var presenter: UserPresenterProtocol?  { get set }
}

//MARK: View -
protocol UserViewProtocol: class {

  var presenter: UserPresenterProtocol?  { get set }
}
