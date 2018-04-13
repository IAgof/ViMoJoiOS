//
//  KindOfProjectViewController.swift
//  vimojo
//
//  Created Jesus Huerta on 02/04/2018.
//  Copyright © 2018 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
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
    var project: Project! {
        didSet {
            self.projectInfo = project?.projectInfo
        }
    }
    var projectInfo: ProjectInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        addTableView()
        addButtons()
        configureTableView()
        // TODO: Change to localized texts
        arrayOfCellData = [
            KindOfProjectViewModel(text: "Falso directo", option: projectInfo.fakeDirect,
                                   updateOption: { [weak self] newOption in
                                    self?.projectInfo.fakeDirect = newOption
            }),
            KindOfProjectViewModel(text: "Vídeo en bruto", option: projectInfo.bruteVideo,
                                   updateOption: { [weak self] newOption in
                                    self?.projectInfo.bruteVideo = newOption
            }),
            KindOfProjectViewModel(text: "Colas", option: projectInfo.queue,
                                   updateOption: { [weak self] newOption in
                                    self?.projectInfo.queue = newOption
            }),
            KindOfProjectViewModel(text: "Gráfico", option: projectInfo.grafic,
                                   updateOption: { [weak self] newOption in
                                    self?.projectInfo.grafic = newOption
            }),
            KindOfProjectViewModel(text: "Piezas", option: projectInfo.pieces,
                                   updateOption: { [weak self] newOption in
                                    self?.projectInfo.pieces = newOption
            })
        ]
    }
    private func updateProjectInfo() {
        
    }
    fileprivate func addButtons() {
        acceptButton = UIButton.acceptButton
        acceptButton.add(for: .touchUpInside) { [weak self] in
            if let projectInfo = self?.projectInfo {
                self?.updateProjectInfo()
                self?.project?.projectInfo = projectInfo
            }
            self?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        cancelButton = UIButton.cancelButton
        cancelButton.add(for: .touchUpInside) { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
    fileprivate func addTableView() {
        tableView = UITableView(frame: CGRect.zero)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let tableViewHeightSize = arrayOfCellData.count * 50
        return self.view.bounds.height - CGFloat(tableViewHeightSize)
    }
}
