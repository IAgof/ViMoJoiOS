//
//  KindOfProjectViewController.swift
//  vimojo
//
//  Created Jesus Huerta on 02/04/2018.
//  Copyright © 2018 Videona. All rights reserved.
//


import UIKit
import VideonaProject

struct KindOfProjectViewModel {
    let text: String
    var option: Bool
    var updateOption: (Bool) -> Void
}
extension UIButton {
    static var cancelButton: UIButton {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "activity_edit_cancel_normal"), for: .normal)
        return button
    }
    static var acceptButton: UIButton {
        let button = UIButton(frame: .zero)
        button.setImage(#imageLiteral(resourceName: "activity_edit_accept_normal"), for: .normal)
        return button
    }
}
class KindOfProjectViewController: ViMoJoController {
    
    var arrayOfCellData = [KindOfProjectViewModel]()
    var tableView: UITableView!
    var cancelButton: UIButton!
    var acceptButton: UIButton!
    var projectInfo: ProjectInfo!
    var project: Project! {
        didSet {
            self.projectInfo = project?.projectInfo
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addTableView()
        addButtons()
        configureTableView()
        arrayOfCellData = ProjectInfo.ProductTypes.allValues.map { productType in
            return KindOfProjectViewModel(text: productType.localizedValue,
                                          option: projectInfo.productTypes.contains(productType)) { isSelected in
                                            if isSelected {
                                                self.projectInfo.productTypes.append(productType)
                                                self.projectInfo.productTypes.removeDuplicates()
                                            } else {
                                                self.projectInfo.productTypes = self.projectInfo.productTypes.filter { $0 != productType }
                                            }
            }
        }
    }
    fileprivate func addButtons() {
        acceptButton = UIButton.acceptButton
        acceptButton.add(for: .touchUpInside) { [weak self] in
            if let projectInfo = self?.projectInfo {
                self?.project?.projectInfo = projectInfo
            }
            self?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
        }
        cancelButton = UIButton.cancelButton
        cancelButton.add(for: .touchUpInside) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
    fileprivate func addTableView() {
        tableView = UITableView(frame: CGRect.zero)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    private func configureTableView() {
        tableView.register(KindOfProjectTableViewCell.self,
                           forCellReuseIdentifier: KindOfProjectTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsMultipleSelection = false
        tableView.dataSource = self
    }
}

extension KindOfProjectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KindOfProjectTableViewCell.identifier, for: indexPath) as? KindOfProjectTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(viewModel: arrayOfCellData[indexPath.row])
        return cell
    }
    private func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tableViewHeightSize = arrayOfCellData.count * 50
        return self.view.bounds.height - CGFloat(tableViewHeightSize)
    }
}
