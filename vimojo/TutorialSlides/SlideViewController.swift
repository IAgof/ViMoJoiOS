//
//  ViewController.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import UIKit
import SnapKit

class SlideViewController: UIViewController {
    var images: [UIImage] = []
    var orientation: UIInterfaceOrientation = .portrait {
        didSet {
            let value = orientation.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        let slideView: SliderView = SliderView()
        slideView.images = images
        self.view.addSubview(slideView)
        slideView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        let exitButton = UIButton()
        exitButton.setTitle("exit".localized(.settings), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonPush), for: .touchUpInside)
        self.view.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    @objc func exitButtonPush() {
        self.navigationController?.popViewController(animated: true)
    }
}
