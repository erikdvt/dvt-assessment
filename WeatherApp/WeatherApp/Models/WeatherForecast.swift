//
//  WeatherForecast.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

struct WeatherForecast {
    var day: String?
    var condition: WeatherCondition?
    var temperature: Int?
}

extension WeatherForecast {
    
    init(response: List?, day: String?) {
        self.condition = WeatherCondition(weatherId: response?.weather.first?.id)
        self.temperature = response?.main?.temp.map(Int.init)
        self.day = day
    }
}
