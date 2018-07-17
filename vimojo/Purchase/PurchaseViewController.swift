//
//  PurchaseViewController.swift
//  vimojo
//
//  Created Alejandro Arjonilla Garcia on 15/12/17.
//  Copyright © 2017 Videona. All rights reserved.
//


import UIKit

class PurchaseViewController: UIViewController, PurchaseViewProtocol {

	var presenter: PurchasePresenterProtocol?
    var alertController: AIndicatorAlertController?
    
    @IBOutlet weak var tableView: UITableView!
    var products: [ProductViewModel] = [] {
        didSet{
            tableView.reloadDataMainThread()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.loadProducts()
        NotificationCenter.default.addObserver(self, selector: #selector(restoredPurchases), name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification), object: nil)
        if navigationController == nil {
            let dismissButton = UIButton(frame: CGRect(x: self.view.width/2 - 50,
                                                       y: self.view.height - 50,
                                                       width: 100, height: 30))
            dismissButton.setTitle("activity_drawer_alert_option_cancel".localized(.drawerMenu), for: .normal)
            dismissButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
            self.view.addSubview(dismissButton)
        }
        
        let restoreButton = UIButton()
        restoreButton.setTitle("action_restore".localized(.purchase), for: .normal)
        restoreButton.titleLabel?.adjustsFontSizeToFitWidth = true
        restoreButton.addTarget(self, action: #selector(restoreTapped), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: restoreButton)
        
        barItem.customView?.snp.makeConstraints({ (make) in
            make.height.equalTo(22)
        })

        self.navigationItem.rightBarButtonItem  = barItem
        configureTable()
    }
    @objc private func restoreTapped() {
        let newAlertController = AIndicatorAlertController(title: "Restore".localized(.purchase),
                                                           message: "Restoring purchases\nplease wait",
                                                           defaultActionButtonTitle: "Cancel".localized(.editor),
                                                           tintColor: configuration.mainColor)
        self.present(newAlertController, animated: true, completion: {
            self.alertController = newAlertController
        })
        presenter?.restoreProducts()
    }
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
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
    @objc func restoredPurchases() {
        alertController?.dismiss(animated: true, completion: {
            self.alertController = nil
        })
        presenter?.loadProducts()
    }
}

extension PurchaseViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier:
                PurchaseTableViewCell.reuseIdentifier,
                                 for: indexPath) as? PurchaseTableViewCell else { return UITableViewCell() }
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
