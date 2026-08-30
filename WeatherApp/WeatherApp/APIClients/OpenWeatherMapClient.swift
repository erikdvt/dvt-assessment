//
//  OpenWeatherMapClient.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

import Foundation
import CoreLocation

protocol OpenWeatherMapClient {
    
    func getCurrentWeather(coordinates: CLLocationCoordinate2D) async throws -> CurrentWeatherResponse
    func getFiveDayWeatherForecast(coordinates: CLLocationCoordinate2D) async throws -> WeatherForecastResponse
    
}

final class OpenWeatherMapAPIClient: OpenWeatherMapClient {

    private let networkManager = NetworkManager()
    private let apiKey = "dec9a20db1796c9d8866e4f4b60ae74d"

    func getCurrentWeather(coordinates: CLLocationCoordinate2D) async throws -> CurrentWeatherResponse {

        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")

        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinates.latitude)),
            URLQueryItem(name: "lon", value: String(coordinates.latitude)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        return try await networkManager.fetchRequest(url: components?.url, errorType: CurrentWeatherResponse.self)
    }
    
    func getFiveDayWeatherForecast(coordinates: CLLocationCoordinate2D) async throws -> WeatherForecastResponse {
        
        var components = URLComponents(string: "api.openweathermap.org/data/2.5/forecast/daily")

        components?.queryItems = [
            URLQueryItem(name: "lat", value: String(coordinates.latitude)),
            URLQueryItem(name: "lon", value: String(coordinates.latitude)),
            URLQueryItem(name: "cnt", value: "5"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric")
        ]

        return try await networkManager.fetchRequest(url: components?.url, errorType: WeatherForecastResponse.self)
    }
}
