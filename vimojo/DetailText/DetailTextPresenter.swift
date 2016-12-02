//
//  DetailTextPresenter.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class DetailTextPresenter: NSObject,DetailTextPresenterInterface {
    var wireframe: DetailTextWireframe?
    var delegate: DetailTextPresenterDelegate?
    var interactor: DetailTextInteractorInterface?
    
    
    func pushBack() {
        wireframe?.goPrevController()
    }
    
    func setTextOnView(_ text:String) {
        let textToView = interactor?.getTextFromInternalMemory(text)
        delegate?.setTextToTextView(textToView!)
    }
}
