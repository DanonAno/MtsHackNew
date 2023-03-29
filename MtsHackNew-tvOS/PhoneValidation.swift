//
//  PhoneValidation.swift
//  MtsHackNew-tvOS
//
//  Created by  Даниил on 29.03.2023.
//

import Foundation

class PhoneValidation {
    static func validate(value: String) -> Bool {
        let phoneRegex = "^\\+7\\s\\(\\d{3}\\)\\s\\d{3}\\-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)
    }
}
