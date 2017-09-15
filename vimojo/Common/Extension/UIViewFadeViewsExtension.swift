//
//  UIViewFadeViewsExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 12/1/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension UIView {
    func fadeInViews(_ views: [UIView]) {
        for view in views {
            view.isHidden = false
        }

        UIView.animate(withDuration: 0.5, animations: {
            for view in views {
                view.alpha = 0
            }

            for view in views {
                view.alpha = 1
            }
        })
    }

    func fadeOutViews(_ views: [UIView]) {
        UIView.animate(withDuration: 0.5, animations: {
            for view in views {
                view.alpha = 0
            }

        }, completion: {
            success in
            if success {
                for view in views {
                    view.isHidden = true
                }
            }
        })
    }
}
