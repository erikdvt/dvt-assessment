//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

struct CurrentWeather {
    var condition: WeatherCondition?
    var min: Int?
    var current: Int?
    var max: Int?
}

extension CurrentWeather {
    init(response: CurrentWeatherResponse) {
        self.condition = WeatherCondition(weatherId: response.weather.first?.id)
        self.min = response.main?.tempMin.map(Int.init)
        self.current = response.main?.temp.map(Int.init)
        self.max = response.main?.tempMax.map(Int.init)
    }
}
