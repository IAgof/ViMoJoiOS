//
//  SlideView.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import Foundation
import paper_onboarding

class SliderView: PaperOnboarding,
PaperOnboardingDelegate, PaperOnboardingDataSource {
    private var images: [UIImage]
    private var positionImage: UIImage?
    var onboardingItemInfo: (UIImage, UIImage) -> OnboardingItemInfo {
        return { image, positionImage in
            OnboardingItemInfo(image, "", "",positionImage,
                               UIColor.red, UIColor.red,
                               UIColor.red, UIFont.boldSystemFont(ofSize: 12),
                               UIFont.boldSystemFont(ofSize: 10))
        }
    }
    init(images: [UIImage], positionImage: UIImage) {
        self.images = images
        self.positionImage = positionImage
        super.init(itemsCount: images.count)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        images = []
        super.init(coder: aDecoder)
    }
    func onboardingItemsCount() -> Int {
        return images.count
    }
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        return onboardingItemInfo(images[index], positionImage ?? UIImage())
    }
}
