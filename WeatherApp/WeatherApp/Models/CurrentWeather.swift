//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

import Foundation

struct CurrentWeather {
    var condition: WeatherCondition?
    var city: String?
    var min: Int?
    var current: Int?
    var max: Int?
    var lastUpdated: Date?
}

extension CurrentWeather {
    init(response: CurrentWeatherResponse) {
        self.condition = WeatherCondition(weatherId: response.weather.first?.id)
        self.city = response.name
        self.min = response.main?.tempMin.map(Int.init)
        self.current = response.main?.temp.map(Int.init)
        self.max = response.main?.tempMax.map(Int.init)
        if let dt = response.dt {
            self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(dt))
        } else {
            self.lastUpdated = Date()
        }
    }
}
