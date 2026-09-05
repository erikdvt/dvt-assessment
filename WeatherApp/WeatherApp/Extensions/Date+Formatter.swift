//
//  Date+Formatter.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//

import Foundation

extension Date {
    var formattedValue: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
