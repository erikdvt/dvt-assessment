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
    
    init?(weatherId: Int?) {
        guard let weatherId else { return nil }
        
        switch weatherId {
        case ..<800:
            self = .rainy
        case 800:
            self = .sunny
        default:
            self = .cloudy
        }
    }
    
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
