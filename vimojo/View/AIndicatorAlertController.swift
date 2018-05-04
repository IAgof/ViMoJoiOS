//
//  AIndicatorAlertController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 23.04.18.
//  Copyright © 2018 Videona. All rights reserved.
//

import UIKit

class AIndicatorAlertController: UIAlertController {
    var backgroundView: UIView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        activityIndicator.center = CGPoint(x: 130.5, y: 67)
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    func addCancelAction(action: (() -> Void)? = nil) {
        addAction(UIAlertAction(title: "Cancel",
                                style: .default, handler: { _ in
                                    action?()
                                    self.dismiss(animated: false, completion: nil)
        }))
    }
}
