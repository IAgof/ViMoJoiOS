//
//  PurchaseViewController.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class PurchaseViewController: UIViewController, PurchaseViewProtocol {

	var presenter: PurchasePresenterProtocol?
    @IBOutlet weak var tableView: UITableView!
    var products: [ProductViewModel] = [] {
        didSet{
            tableView.reloadDataMainThread()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadProducts()
        configureTable()
    }
    private func configureTable() {
        let nib = UINib(nibName: "PurchaseTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: PurchaseTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    func showError(with title: String, description: String) {
        let controller = UIAlertController.defaultAlert(title, description)
        self.present(controller, animated: true, completion: nil)
    }
}

extension PurchaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.reuseIdentifier, for: indexPath) as? PurchaseTableViewCell else { return UITableViewCell() }
        cell.setup(with: products[indexPath.row])
        return cell
    }
}
extension UIAlertController {
    static var defaultAlert: (String, String) -> UIAlertController {
            return { title, description in
                let controller = UIAlertController(title: title, message: description, defaultActionButtonTitle: "OK", tintColor: .red)
                return controller
        }
    }
}
