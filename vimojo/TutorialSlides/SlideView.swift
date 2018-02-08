//
//  SlideView.swift
//  paperTest
//
//  Created by Alejandro Arjonilla Garcia on 31.01.18.
//

import Foundation
import FSPagerView
import SnapKit

class SliderView: FSPagerView {
    var images: [UIImage] = [] {
        didSet {
            reloadData()
            pageControl.numberOfPages = images.count
        }
    }
    var positionImage: UIImage?
    var pageControl: FSPageControl
    
    override init(frame: CGRect) {
        pageControl = FSPageControl(frame: CGRect.zero)
        super.init(frame: frame)
        addPageControl()
        configureFSpagerView()
    }
    required init?(coder aDecoder: NSCoder) {
        pageControl = FSPageControl(frame: CGRect.zero)
        super.init(coder: aDecoder)
        configureFSpagerView()
    }
    func addPageControl() {
        self.addSubview(pageControl)
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-8)
            make.centerX.equalToSuperview()
        }
    }
    func configureFSpagerView() {
        register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        dataSource = self
        delegate = self
        transformer = FSPagerViewTransformer(type: .zoomOut)
    }
}

extension SliderView: FSPagerViewDataSource, FSPagerViewDelegate {
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return images.count
    }
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = images[index]
        return cell
    }
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        pageControl.currentPage = index
    }
}
