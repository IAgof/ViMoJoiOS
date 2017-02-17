//
//  RecordDrawerController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation
import KYDrawerController

class RecordDrawerController: UIViewController {
    var wireframe:RecordDrawerWireframe?
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func pushProjects(_ sender: Any) {
        wireframe?.presentProjectsSelector()
    }
    
    @IBAction func pushNewProject(_ sender: Any) {
        wireframe?.presentGoToRecordOrGalleryWireframe()
    }
    
    func closeDrawer(){
        if let parentController = (self.parent as? KYDrawerController){
            parentController.setDrawerState(.closed, animated: true)
        }
    }
}

extension RecordDrawerController:KYDrawerControllerDelegate{
    func viewWillAppear() {
        closeDrawer()
    }
}
