//
//  PurchaseTableViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 16/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    static var reuseIdentifier: String = "PurchaseTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    private var action: Action?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.wordWrap()
        descriptionLabel.wordWrap()
        selectionStyle = .none
    }
    func setup(with viewModel: ProductViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        action = viewModel.buyAction
        buyButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }
    func tapButton() {
        action?()
    }
}

extension UILabel {
    func wordWrap() {
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
}
