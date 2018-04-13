//
//  KindOfProjectTableViewCell.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 13.04.18.
//  Copyright © 2018 Videona. All rights reserved.
//

import UIKit

class KindOfProjectTableViewCell: UITableViewCell {
    override var reuseIdentifier: String? {
        return KindOfProjectTableViewCell.identifier
    }
    static let identifier = "KindOfProjectTableViewCell"
    
    var label: UILabel!
    var optionSwitch: UISwitch!
    var viewModel: KindOfProjectViewModel! {
        didSet {
            label.text = viewModel.text
            optionSwitch.isOn = viewModel.option
        }
    }
    
    // MARK: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configView()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        configView()
    }
    override func prepareForInterfaceBuilder() {
        super.awakeFromNib()
        configView()
    }
    // MARK: Config View
    private func configView() {
        self.backgroundColor = .clear
        selectionStyle = .none
        addLabel()
        addSwitch()
        makeConstraints()
        optionSwitch.addTarget(self, action: #selector(switchValueChanged(view:)), for: .valueChanged)
    }
    @objc func switchValueChanged(view: UISwitch) {
        viewModel.updateOption(view.isOn)
    }
    func setup(viewModel: KindOfProjectViewModel) {
        self.viewModel = viewModel
    }
    fileprivate func addLabel() {
        label = UILabel(frame: CGRect.zero)
        self.addSubview(label)
    }
    fileprivate func addSwitch() {
        optionSwitch = UISwitch(frame: CGRect.zero)
        self.addSubview(optionSwitch)
    }
    private func makeConstraints() {
        label.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        optionSwitch.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
