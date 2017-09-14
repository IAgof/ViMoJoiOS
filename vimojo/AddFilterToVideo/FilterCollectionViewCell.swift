//
//  FilterCollectionViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 15/2/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!

    override var isSelected: Bool {
        didSet {
            self.filterImageView.layer.borderWidth = (isSelected ? 3 : 0)
            self.filterImageView.layer.borderColor = (isSelected ? configuration.mainColor.cgColor : UIColor.clear.cgColor)
        }
    }

    func setUp(viewModel: FilterCollectionViewModel) {
        DispatchQueue.main.async {
            self.filterImageView.image = self.getImageFiltered(baseImage: viewModel.image,
                                                          filterName: viewModel.name)
        }
        self.filterNameLabel.text = viewModel.displayName
        self.filterNameLabel.adjustsFontSizeToFitWidth = true

        self.selectedBackgroundView?.backgroundColor =  configuration.mainColor
    }

    func getImageFiltered(baseImage: UIImage,
                          filterName: String) -> UIImage {
        guard let filter = CIFilter(name: filterName) else {return baseImage}
        guard let imageCI = CIImage(image: baseImage) else {return baseImage}

        filter.setValue(imageCI, forKey: kCIInputImageKey)
        let imageFiltered = filter.outputImage ?? imageCI

        return UIImage(ciImage: imageFiltered)
    }
}
