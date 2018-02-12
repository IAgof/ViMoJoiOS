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
    private var positionImage: UIImage = #imageLiteral(resourceName: "fuck")
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
        setupOnboardingSliderView()
        setupExitButton()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    @objc func exitButtonPush() {
        self.navigationController?.popViewController(animated: true)
    }
    func setupOnboardingSliderView() {
        let onBoardingPages: SliderView = SliderView()
        onBoardingPages.images = images
        onBoardingPages.positionImage = positionImage
        self.view.addSubview(onBoardingPages)
        onBoardingPages.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    func setupExitButton() {
        let exitButton = UIButton()
        // Change on VIMOJO
        //        exitButton.setTitle("exit".localized(.settings), for: .normal)
        exitButton.setTitle("exit", for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonPush), for: .touchUpInside)
        self.view.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview()
        }
    }
}
