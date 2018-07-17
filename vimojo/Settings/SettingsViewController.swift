//
//  SettingsViewController.swift
//  Videona
//
//  Created by Alejandro Arjonilla Garcia on 11/5/16.
//  Copyright © 2016 Videona. All rights reserved.
//

import UIKit
import Foundation

class SettingsViewController: ViMoJoController,
    UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource {

	@IBOutlet weak var barButton: UIBarButtonItem!
	
	var eventHandler: SettingsPresenterInterface?

    let reuseIdentifierCell = "settingsCell"

    // MARK: - List variables
    var sections = Array<String>()
    var items: [[SettingsViewModel]] = [[]] {
        didSet {
            self.settingsTableView.reloadData()
        }
    }
    // MARK: - Outlets
    @IBOutlet weak var settingsTableView: UITableView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        eventHandler?.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        configureNavigationBarVissible()
        eventHandler?.getItems()
		UIApplication.topViewController()?.navigationItem.leftBarButtonItem = UIBarButtonItem(with: self, image: #imageLiteral(resourceName: "activity_edit_back"), selector: #selector(pushBackBarButton))
	}

	override func viewWillDisappear(_ animated: Bool) {
		configureNavigationBarHidden()
	}
	
    // MARK: - Actions
    @IBAction func pushBackBarButton(_ sender: AnyObject) {
        eventHandler?.pushBack()
    }

    // MARK: - UITableview datasource
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.sections[section]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30)) //set these values as necessary
        returnedView.backgroundColor = UIColor.white

        let label = UILabel(frame: CGRect(x: 8, y: 0, width: tableView.bounds.size.width, height: 30))
        label.text = self.sections[section]
        label.textColor = configuration.mainColor
        returnedView.addSubview(label)

        return returnedView
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return sections.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.items[section].count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? =
            tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell)
        if (cell != nil) {
            cell = UITableViewCell(style: .value1,
                                   reuseIdentifier: reuseIdentifierCell)
        }
        // Configure the cell...
        let item = self.items[indexPath.section][indexPath.item]

        cell?.textLabel?.text = item.title
        cell?.detailTextLabel?.text = item.subtitle

        cell!.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell!.textLabel?.adjustsFontSizeToFitWidth = true

        return cell!
    }

    // MARK: - UITableview delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //cell push
        tableView.deselectRow(at: indexPath, animated: false)

        eventHandler?.itemListSelected(indexPath)
    }
}

extension SettingsViewController:SettingsPresenterDelegate {
    // MARK: - init view
    func registerClass() {
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifierCell)
    }

    func addFooter() {
        let footer = UINib(nibName: "VideonaFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView

        let footerTest = UIView.init(frame: footer.frame)
        footerTest.addSubview(footer)

        settingsTableView.tableFooterView = footerTest
    }

    func removeSeparatorTable() {
        settingsTableView.separatorStyle = .none
    }

    func reloadTableData() {
        settingsTableView.reloadData()
    }

    func setSectionsArray(_ sections: [String]) {
        self.sections = sections
    }

    func setItems(_ items: [[SettingsViewModel]]) {
        self.items = items
    }
}
