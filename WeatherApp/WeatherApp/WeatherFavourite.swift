//
//  WeatherFavourite.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import Foundation
import SwiftData

@Model
final class WeatherFavourite {
    var city: String
    var latitude: Double
    var longitude: Double
    
    init(city: String,
         latitude: Double,
         longitude: Double) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
}
