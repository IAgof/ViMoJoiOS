//
//  DetailProjectPresenter.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

class DetailProjectPresenter{
    var wireframe: DetailProjectWireframe?
    var delegate: DetailProjectPresenterDelegate?
    var interactor: DetailProjectInteractorInterface?
}

extension DetailProjectPresenter:DetailProjectPresenterInterface{
    func viewDidLoad() {
        interactor?.searchProjectParams()
    }
    
    func viewWillDissappear() {
    
    }
    
    func accept() {
        
    }
    
    func cancel() {
        
    }
}

extension DetailProjectPresenter:DetailProjectInteractorDelegate{
    func projectFound(params: DetailProjectFound) {
        delegate?.displayParams(viewModel: DetailProjectFoundToDetailProjectViewModelMapper().map(from: params))
    }
}
