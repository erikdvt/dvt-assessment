//
//  Item.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
