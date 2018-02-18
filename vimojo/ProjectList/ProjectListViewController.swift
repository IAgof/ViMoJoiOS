//
//  ProjectListViewController.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 29/11/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import Foundation

class ProjectListViewController: ViMoJoController {
    var eventHandler: ProjectListPresenterInterface?
    let reuseIdentifierCell = "projectListCell"

    var items: [ProjectListViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationBarWithBackButton()
        eventHandler?.viewWillAppear()
        self.navigationController?.isNavigationBarHidden = false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override func pushBack() {
        eventHandler?.pushBack()
    }
}

extension ProjectListViewController:ProjectListPresenterDelegate {
    func setItems(_ items: [ProjectListViewModel]) {
        self.items = items
    }
}

// MARK: - UITableview datasource
extension ProjectListViewController:UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell( withIdentifier: reuseIdentifierCell, for: indexPath) as! ProjectListViewCell
        let itemNumber = indexPath.item
        let item = self.items[itemNumber]

        cell.setup(with: item, itemNumber: itemNumber)

        cell.editProjectButton.addTarget(self, action: #selector(pushEditProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.removeProjectButton.addTarget(self, action: #selector(pushRemoveProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.shareProjectButton.addTarget(self, action: #selector(pushShareProjectButton(sender:)), for: UIControlEvents.touchUpInside)
        cell.duplicateProjectButton.addTarget(self, action: #selector(pushDuplicateProjectButton(sender:)), for: UIControlEvents.touchUpInside)

        return cell
    }

}

extension ProjectListViewController {
    @IBAction func pushEditProjectButton(sender: UIButton) {
        eventHandler?.detailProject(projectNumber: sender.tag)
    }

    @IBAction func pushRemoveProjectButton(sender: UIButton) {
        eventHandler?.removeProject(projectNumber: sender.tag)
    }

    @IBAction func pushShareProjectButton(sender: UIButton) {
        eventHandler?.shareProject(projectNumber: sender.tag)
    }

    @IBAction func pushDuplicateProjectButton(sender: UIButton) {
        eventHandler?.duplicateProject(projectNumber: sender.tag)
    }
}
extension ProjectListViewController:UITableViewDelegate {

    // MARK: - UITableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler?.editProject(projectNumber: indexPath.item)
    }
}
