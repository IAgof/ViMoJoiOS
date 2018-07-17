//
// Created by Alejandro Arjonilla Garcia on 16.11.17.
// Copyright (c) 2017 Tabel. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    var indicatorView: UIActivityIndicatorView!
    var color: UIColor!
    var tapEnabled:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    func setupView() {
        indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicatorView.center = self.center
        indicatorView.startAnimating()
        color = .gray
        self.backgroundColor = #colorLiteral(red: 0.357887849, green: 0.08870502424, blue: 0.1333104564, alpha: 0.49)
        self.addSubview(indicatorView)
        self.alpha = 0

        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        addGestureRecognizer(tap)
    }
    @objc func doubleTapped() {
        if tapEnabled { self.hideAnimated() }
    }
}
extension UIView {
    func showAnimated() {
        guard alpha == 0 else { return }
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1
        }
    }
    func hideAnimated() {
        DispatchQueue.main.async {
            guard self.alpha == 1 else { return }
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }) { (_) in
                self.removeFromSuperview()
            }
        }
    }
}
