//
//  SlideViewController.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import UIKit
import SnapKit

class SlideViewController: UIViewController {
    var images: [UIImage] = []
    private var positionImage: UIImage = #imageLiteral(resourceName: "activity_edit_aperture_control")
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
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
    func exitButtonPush() {
        self.dismiss(animated: true, completion: nil)
    }
}



