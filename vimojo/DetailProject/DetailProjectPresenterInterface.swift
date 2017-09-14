//
//  DetailProjectPresenterInterface.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

protocol DetailProjectPresenterInterface {
    func viewDidLoad()
    func viewWillDissappear()
    func accept()
    func cancel()
    func pushBack()

    func projectNameChange(name: String)
}

protocol DetailProjectPresenterDelegate {
    func displayParams(viewModel: DetailProjectViewModel)
    func setButtonsContainerIsHidden(isHidden: Bool)
}
