//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

enum WeatherCondition {
    case sunny
    case cloudy
    case rainy
    
    var displayName: String {
        switch self {
        case .sunny:
            return "Sunny"
        case .cloudy:
            return "Cloudy"
        case .rainy:
            return "Rainy"
        }
    }
    
    var weatherIcon: String {
        switch self {
        case .sunny:
            return "sunnyIcon"
        case .cloudy:
            return "cloudyIcon"
        case .rainy:
            return "rainyIcon"
        }
    }
    
    var backgroundImage: String {
        switch self {
        case .sunny:
            return "sunnyBackground"
        case .cloudy:
            return "cloudyBackground"
        case .rainy:
            return "rainyBackground"
        }
    }
    
    var backgroundColor: String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .rainy:
            return "rainy"
        }
    }
}
