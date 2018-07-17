//
//  String+Extensions.swift
//  TabelRentPlatform
//
//  Created by Alejandro Arjonilla Garcia on 30.10.17.
//  Copyright © 2017 Tabel. All rights reserved.
//

import Foundation

extension String {
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                    range: NSRange.init(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$",
                                                options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                range: NSRange.init(location: 0, length: self.characters.count)) != nil) {
                if (self.characters.count>=6 && self.characters.count<=20) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    var isPhoneNumber: Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  (self == filtered) && (filtered.count >= 9)
    }
    var dataUTF8: Data? {
        return self.data(using: String.Encoding.utf8)
    }
}

extension Optional where Wrapped == String {
    var nonOptional: String {
        if let string = self { return string }
        else { return "" }
    }
}

