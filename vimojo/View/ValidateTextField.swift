//
//  ValidateTextField.swift
//  TabelRentPlatform
//
//  Created by Alejandro Arjonilla Garcia on 23.10.17.
//  Copyright © 2017 Tabel. All rights reserved.
//

import UIKit
import RxSwift

enum ValidateState {
    case none
    case valid
    case invalid

    var image: UIImage? {
        switch self {
        case .none: return nil
        case .valid: return #imageLiteral(resourceName: "ok_validate_text_field")
        case .invalid: return #imageLiteral(resourceName: "fail_validate_text_field")
        }
    }
    var isValid: Bool {
        switch self {
        case .none, .invalid: return false
        case .valid: return true
        }
    }
}

class ValidateTextField: UITextField {
    private var disposableBag = DisposeBag()
    var isValid: Variable<ValidateState> = Variable<ValidateState>(.none)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    private func setup() {
        self.borderStyle = .roundedRect
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.textColor = .black
        isValid.asObservable().skip(2).subscribe { (valid) in
            guard let image = valid.element?.image else { return }
            let imageView = UIImageView(image: image)
            self.rightViewMode = .always
            self.rightViewRect(forBounds: imageView.frame)
            self.rightView = imageView
        }.disposed(by: disposableBag)
    }
}
