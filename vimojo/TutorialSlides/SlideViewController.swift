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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let onBoardingPages: SliderView = SliderView(images: images,
                                                       positionImage: positionImage)
        self.view.addSubview(onBoardingPages)
        onBoardingPages.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}



