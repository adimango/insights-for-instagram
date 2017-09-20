//
//  AppExtensions.swift
//  insights-for-instagram
//
//  Created by Alex Di Mango on 02/09/2017.
//  Copyright © 2017 Alex Di Mango. All rights reserved.
//

import UIKit

// MARK: - Formatter

extension Formatter {
    static let withPoint: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}

// MARK: - Integer

extension Integer {
    var formattedWithPoint: String {
        return Formatter.withPoint.string(for: self) ?? ""
    }
}

// MARK: - String

extension String {
    
    /// -returns: A string without white spaces and new lines.
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
