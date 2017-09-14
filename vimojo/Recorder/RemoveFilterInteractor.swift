//
//  RemoveFilterInteractor.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 25/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation
import GPUImage

class RemoveFilterInteractor: NSObject {
    func removeFilter(_ actualFilter: GPUImageFilter, imageView: UIImageView, display: GPUImageView) {
        let image = UIImage.init(named: "filter_free")
        imageView.image = image

        actualFilter.removeAllTargets()
    }

    func removeShader(_ actualFilter: GPUImageFilter, display: GPUImageView) {
        actualFilter.removeAllTargets()
    }
    func removeOverlay(_ imageView: UIImageView) {
        let image = UIImage.init(named: "filter_free")
        imageView.image = image
    }
}
