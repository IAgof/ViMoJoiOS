//
//  UIViewController+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 8/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation

extension UIViewController {
    func moveViewTo(x: CGFloat = 0, y: CGFloat = 0) {
        self.view.moveTo(x: x, y: y)
    }
    func moveViewTo(point: CGPoint) {
        self.view.moveTo(point: point)
    }
}
extension UIView {
    func moveTo(x: CGFloat = 0, y: CGFloat = 0) {
        moveTo(point: CGPoint(x: self.frame.origin.x + x,
                              y: self.frame.origin.y + y))
    }
    func moveTo(point: CGPoint) {
        UIView.animate(withDuration: 0.5) {
            self.frame.origin = point
        }
    }
}
extension CGPoint {
    func changeY(yPos: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: yPos)
    }
}
