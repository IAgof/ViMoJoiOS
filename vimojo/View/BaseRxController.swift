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
import Whisper

protocol BaseViewProtocol {
    func showWhisper(with message: String, color: UIColor)
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
    func showWhisper(with message: String = "", color: UIColor = .red) {
        guard let navigationController = navigationController else { return }
        let message = Message(title: message, backgroundColor: color)
        Whisper.show(whisper: message, to: navigationController, action: .show)
    }
}
