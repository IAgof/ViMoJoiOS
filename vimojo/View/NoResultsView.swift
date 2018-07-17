//
//  NoResultsView.swift
//  LoginProject
//
//  Created by Alejandro Arjonilla Garcia on 02.02.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
typealias LoginResponseCallBack = (DefaultResponse) -> Void

class NoResultsView: UIView {
    var tapButtonAction: Action?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    func setupView() {
        let label = UILabel()
        label.text = "no_results_available"
        let button = UIButton()
        button.setTitle("table_button_try_again".localized(.settings), for: .normal)
        button.addTarget(self, action: #selector(tryAgainTapped), for: .touchUpInside)
        self.addSubview(label)
        self.addSubview(button)
        label.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        button.snp.makeConstraints { (make) in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.centerX.equalTo(label.snp.centerX)
        }
    }
    @objc func tryAgainTapped() {
        tapButtonAction?()
    }
}
