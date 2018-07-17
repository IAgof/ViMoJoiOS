//
//  BaseRxController.swift
//  LoginProject
//
//  Created by Alejandro Arjonilla Garcia on 02.02.18.
//  Copyright © 2018 Alejandro Arjonilla Garcia. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

protocol BaseViewProtocol {
    func showWhisper(with message: String, color: UIColor)
    func showDefaultAlert(title: String?, message: String?, okAction: Action?, cancelAction: Action?)
}
extension UINavigationController {
    static var transparent: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.tintColor = .white
        return navigationController
    }
}
class BaseRxController: UIViewController {
    var disposableBag: DisposeBag = DisposeBag()
    internal var loadingView: LoadingView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    func configureViews() {}
    func addLoadingView() {
        guard loadingView == nil else { return }
        DispatchQueue.main.async {
            let view = LoadingView(frame: self.view.frame)
            self.view.addSubview(view)
            self.loadingView = view
            self.loadingView?.showAnimated()
        }
    }
    func removeLoadingView() {
        loadingView?.hideAnimated()
        loadingView = nil
    }
}
