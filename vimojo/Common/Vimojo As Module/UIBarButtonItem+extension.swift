//
//  UIBarButtonItem+extension.swift
//  vimojo
//
//  Created by Jesus Huerta on 18/10/2017.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension UIBarButtonItem{
	convenience init(with target: Any?, image: UIImage, selector: Selector, rect: CGRect = CGRect(x: 0, y: 0, width: 22, height: 22)) {
		// let button = UIButton(frame: rect)
		let button = UIButton(type: .custom)
		button.setImage(image, for: .normal)
		button.addTarget(target, action: selector, for: .touchUpInside)
		self.init(customView: button)
		// This should help displaying much better the icons but it doesn't happen
		// button.topAnchor.constraint(equalTo: (self.customView?.topAnchor)!).isActive = true
		// button.bottomAnchor.constraint(equalTo: (self.customView?.bottomAnchor)!).isActive = true
		// button.leadingAnchor.constraint(equalTo: (self.customView?.leadingAnchor)!).isActive = true
	}
}
