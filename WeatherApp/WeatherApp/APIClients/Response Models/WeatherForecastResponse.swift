//
//  WeatherForecastResponse.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

import Foundation

// MARK: - WeatherForecastResponse
struct WeatherForecastResponse: Codable {
    let city: City?
    let cod: String?
    let message: Double?
    let cnt: Int?
    let list: [List]
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let sunrise: Int?
    let sunset: Int?
    let temp: Temp?
    let feelsLike: FeelsLike?
    let pressure: Int?
    let humidity: Int?
    let weather: [Weather]
    let speed: Double?
    let deg: Int?
    let gust: Double?
    let clouds: Int?
    let pop: Double?
    let rain: Double?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case sunrise = "sunrise"
        case sunset = "sunset"
        case temp = "temp"
        case feelsLike = "feels_like"
        case pressure = "pressure"
        case humidity = "humidity"
        case weather = "weather"
        case speed = "speed"
        case deg = "deg"
        case gust = "gust"
        case clouds = "clouds"
        case pop = "pop"
        case rain = "rain"
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
}

// MARK: - Temp
struct Temp: Codable {
    let day: Double?
    let min: Double?
    let max: Double?
    let night: Double?
    let eve: Double?
    let morn: Double?
}
