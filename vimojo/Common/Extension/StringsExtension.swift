//
//  StringsExtension.swift
//  vimojo
//
//  Created by Alejandro Arjonilla Garcia on 28/5/17.
//  Copyright © 2017 Videona. All rights reserved.
//

import Foundation

extension String {
    func localize(inTable table: String? = nil) -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: table)
    }
}
