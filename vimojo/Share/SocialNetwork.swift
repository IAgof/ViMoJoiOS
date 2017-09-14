//
//  Social.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 13/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import UIKit

class SocialNetwork: NSObject {
    var iconId: String
    var iconIdPressed: String
    var title: String
    var action: ShareActionInterface

    init(iconId: String, iconIdPressed: String, title: String, action: ShareActionInterface) {
        self.iconId = iconId
        self.title = title
        self.iconIdPressed = iconIdPressed
        self.action = action
    }

    func getIconId() -> String {
        return iconId
    }
    func getIconIdPressed() -> String {
        return iconIdPressed
    }
    func getTitle() -> String {
        return title
    }
}
