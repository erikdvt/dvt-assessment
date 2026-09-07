// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let WeatherForecastResponse = try? JSONDecoder().decode(WeatherForecastResponse.self, from: jsonData)

import Foundation

// MARK: - WeatherForecastResponse
struct WeatherForecastResponse: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]
    let city: City?
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: Main?
    let weather: [Weather]
    let clouds: Clouds?
    let wind: Wind?
    let visibility: Int?
    let pop: Double?
    let rain: Rain?
    let sys: Sys?
    let dtTxt: String?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case visibility = "visibility"
        case pop = "pop"
        case rain = "rain"
        case sys = "sys"
        case dtTxt = "dt_txt"
    }
}

// MARK: - City
struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
    let population: Int?
    let timezone: Int?
    let sunrise: Int?
    let sunset: Int?
}
