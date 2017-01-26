//
//  GoToRecordOrGalleryViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class GoToRecordOrGalleryViewController: ViMoJoController {
    var wireframe:GoToRecordOrGalleryWireframe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
        self.view.backgroundColor = configuration.mainColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func pushGoToGallery(_ sender: Any) {
        wireframe?.presentGallery()
    }
    
    @IBAction func pushGoToRecordVideo(_ sender: Any) {
        wireframe?.presentRecorder()
    }
}
