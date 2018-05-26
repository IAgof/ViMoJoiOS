//
//  CreateDefaultProjectUseCase.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 25/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import VideonaProject

public class CreateDefaultProjectUseCase {
    public static func loadOrCreateProject() -> Project {
        let project = ProjectRealmRepository().getCurrentProject()
        if configuration.IS_WATERMARK_PURCHABLE {
            project.hasWatermark = PurchaseProduct
                .isProductPurchased(product: .removeWatermark)
        } else {
            project.hasWatermark = configuration.IS_WATERMARK_ENABLED
        }
        return project
    }
}
