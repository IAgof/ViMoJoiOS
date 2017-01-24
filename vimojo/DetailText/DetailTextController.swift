//
//  DetailTextController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 9/6/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit

class DetailTextController: ViMoJoController,DetailTextPresenterDelegate{
    var eventHandler: DetailTextPresenterInterface?
    
    @IBOutlet weak var detailTextFiled: UITextView!
    
    var textRef: String? {
        didSet {
//            eventHandler?.setTextOnView(textRef!)
        }
    }
    
    func setTextToTextView(_ text: String) {
        detailTextFiled.text = text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandler?.setTextOnView(textRef!)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithBackButton()
    }
    override func pushBack() {
        eventHandler?.pushBack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
