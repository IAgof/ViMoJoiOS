//
//  UIViewController+Extension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 8/2/18.
//  Copyright © 2018 Videona. All rights reserved.
//

import Foundation
import Whisper

extension UIViewController {
    func moveViewTo(x: CGFloat = 0, y: CGFloat = 0) {
        self.view.moveTo(x: x, y: y)
    }
    func moveViewTo(point: CGPoint) {
        self.view.moveTo(point: point)
    }
    func showDefaultAlert(title: String?, message: String?,
                          okAction: Action? = nil, cancelAction: Action? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            okAction?()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            cancelAction?()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    func showWhisper(with message: String = "", color: UIColor = .red) {
        guard let navigationController = navigationController else { return }
        let message = Message(title: message, backgroundColor: color)
        Whisper.show(whisper: message, to: navigationController, action: .show)
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
enum VimojoError: Error {
    case save, recording, message(String)
    
    var localizedDescription: String {
        switch self {
        case .save: return "Error saving video, sorry for inconvenience".localized(.editor)
        case .recording: return "Error recording your video, sorry for inconvenience".localized(.editor)
        case .message(let message): return message
        }
    }
}
extension UIViewController {
    
    func showError(error: VimojoError) {
        let alertController = UIAlertController(title: "Ups!", message: error.localizedDescription, defaultActionButtonTitle: "Ok")
        self.present(alertController, animated: true, completion: nil)
    }
}
