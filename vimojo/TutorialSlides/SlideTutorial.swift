//
//  SlideTutorial.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import Foundation
import UIKit

enum SlideTutorial {
    case tutorialOne
    case tutorialTwo
    
    var viewController: SlideViewController {
        let newSlideController = SlideViewController()
        newSlideController.images = images
        return newSlideController
    }
    
    private var images: [UIImage] {
        switch self {
        case .tutorialOne:
            return [#imageLiteral(resourceName: "one"),#imageLiteral(resourceName: "twpo"),#imageLiteral(resourceName: "three")]
        case .tutorialTwo:
            return [#imageLiteral(resourceName: "three"),#imageLiteral(resourceName: "twpo"),#imageLiteral(resourceName: "one")]
        }
    }
}
