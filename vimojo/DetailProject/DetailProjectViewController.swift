//
//  DetailProjectViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 24/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class DetailProjectViewController: ViMoJoController {

    //MARK: Outlets
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var projectNameTextField: UITextField!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var filesizeLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var formatLabel: UILabel!
    @IBOutlet weak var bitrateLabel: UILabel!
    @IBOutlet weak var frameRateLabel: UILabel!
    @IBOutlet weak var cancelAndAcceptViewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: Actions
    @IBAction func pushAcceptButton(_ sender: Any) {
    
    }
    
    @IBAction func pushCancelButton(_ sender: Any) {
    
    }
}

extension DetailProjectViewController:DetailProjectPresenterDelegate{
    
}
