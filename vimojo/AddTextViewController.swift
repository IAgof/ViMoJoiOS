//
//  AddTextViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 27/9/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class AddTextViewController: ViMoJoController,AddTextPresenterDelegate {
    var eventHandler: AddTextPresenterInterface?
    
    @IBOutlet weak var topTextConfigButton: UIButton!
    @IBOutlet weak var midTextConfigButton: UIButton!
    @IBOutlet weak var bottomTextConfigButton: UIButton!
    @IBOutlet weak var AddTextTextField: UITextField!
    
    
    @IBAction func topTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func midTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func bottomTextButtonPushed(sender: AnyObject) {
        
    }
    
    @IBAction func addTextTextfieldChanged(sender: AnyObject) {
    
    }
    @IBAction func cancelButtonPushed(sender: AnyObject) {
        
    }
    @IBAction func acceptButtonPushed(sender: AnyObject) {
        
    }
    
}