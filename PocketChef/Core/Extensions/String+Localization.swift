//
//  String+Localization.swift
//  PocketChef
//
//  Created by Rodrigo Cerqueira Reis on 24/11/25.
//

import Foundation

extension String {
    var localized: String {
        return String(localized: LocalizationValue(self))
    }
}
