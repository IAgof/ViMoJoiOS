//
//  UIViewController+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 8/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

extension UIViewController {
    func moveViewTo(point: CGPoint) {
        UIView.animate(withDuration: 0.5) {
             self.view.frame.origin = point
        }
    }
}
extension CGPoint {
    func changeY(yPos: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: yPos)
    }
}
