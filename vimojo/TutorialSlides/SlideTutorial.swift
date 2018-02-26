//
//  SlideTutorial.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import Foundation
import UIKit

enum SlideTutorial {
    case recordingTut
    case editTut
    
    var viewController: SlideViewController {
        let newSlideController = SlideViewController()
        newSlideController.images = images
        newSlideController.orientation = orientation
        return newSlideController
    }
    private var orientation: UIInterfaceOrientation {
        switch self {
        case .recordingTut: return .landscapeRight
        case .editTut: return .portrait
        }
    }
    private var images: [UIImage] {
        var images: [UIImage] = []
        switch self {
        case .recordingTut:
            let prefix = UIApplication.shared.isSpanish ? "rec-tutorial-esp_": "rec-tutorial-eng_"
            images = getImages(with: prefix, numerImages: 11)
        case .editTut:
            let prefix = UIApplication.shared.isSpanish ? "edit-tutorial-esp_": "edit-tutorial-eng_"
            images = getImages(with: prefix, numerImages: 11)
        }
        return images
    }
    private func getImages(with prefix: String, numerImages: Int) -> [UIImage] {
        var images: [UIImage] = []
        for index in 1...11 {
            let name = "\(prefix)\(index)"
            images.append(UIImage(named: name)!)
        }
        return images
    }
}

extension UIApplication {
    var languageCode: String {
        let supportedLanguageCodes = ["en", "es"]
        let languageCode = Locale.current.languageCode ?? "en"
        
        return supportedLanguageCodes.contains(languageCode) ? languageCode : "en"
    }
    var isSpanish: Bool {
        return UIApplication.shared.languageCode == "es"
    }
}
