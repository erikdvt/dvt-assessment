//
//  MockWeatherClient.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//

import Foundation
import CoreLocation

class MockWeatherClient: WeatherClientType {
    
    var getCurrentWeatherShouldSucceed: Bool = true
    var getWeatherForecastShouldSucceed: Bool = true
    
    func getCurrentWeather(coordinates: CLLocationCoordinate2D) async throws -> WeatherApp.CurrentWeatherResponse {
        if getCurrentWeatherShouldSucceed {
            return CurrentWeatherResponse(
                coord: nil,
                weather: [Weather(id: 800,
                                  main: nil,
                                  description: nil,
                                  icon: nil)],
                base: nil,
                main: Main(temp: 20.0, feelsLike: nil, tempMin: 12.0, tempMax: 21.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                visibility: nil,
                wind: nil,
                rain: nil,
                clouds: nil,
                dt: nil,
                sys: nil,
                timezone: nil,
                id: nil,
                name: nil,
                cod: nil)
        } else {
            throw MockError.currentNetworkError
        }
    }
    
    func getFiveDayWeatherForecast(coordinates: CLLocationCoordinate2D) async throws -> WeatherApp.WeatherForecastResponse {
        guard getWeatherForecastShouldSucceed else {
            throw MockError.forecastNetworkError
        }
        
        return WeatherForecastResponse(
            cod: nil,
            message: nil,
            cnt: 5,
            list: [
                buildWeatherListItem(
                    forDaysFromToday: 1,
                    temp: 20,
                    tempMin: 12,
                    tempMax: 21,
                    weatherId: 800
                ),
                buildWeatherListItem(
                    forDaysFromToday: 2,
                    temp: 19,
                    tempMin: 11,
                    tempMax: 22,
                    weatherId: 801
                ),
                buildWeatherListItem(
                    forDaysFromToday: 3,
                    temp: 8,
                    tempMin: 16,
                    tempMax: 28,
                    weatherId: 799
                ),
                buildWeatherListItem(
                    forDaysFromToday: 4,
                    temp: 14,
                    tempMin: 26,
                    tempMax: 30,
                    weatherId: 800
                ),
                buildWeatherListItem(
                    forDaysFromToday: 5,
                    temp: 18,
                    tempMin: 29,
                    tempMax: 35,
                    weatherId: 801
                )
            ],
            city: nil
        )
    }
    
    private func buildWeatherListItem(forDaysFromToday: Int, temp: Double, tempMin: Double, tempMax: Double, weatherId: Int) -> List {
        List(
            dt: timestamp(forDaysFromToday: forDaysFromToday),
            main: Main(
                temp: temp, feelsLike: nil, tempMin: tempMin, tempMax: tempMax, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
            weather: [Weather(id: weatherId, main: nil, description: nil, icon: nil)],
            clouds: nil,
            wind: nil,
            visibility: nil,
            pop: nil,
            rain: nil,
            sys: nil,
            dtTxt: nil)
    }
    
    private func timestamp(forDaysFromToday days: Int) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.date(
            byAdding: .day,
            value: days,
            to: today
        )!
        
        return Int(date.timeIntervalSince1970)
    }
}

enum MockError: Error {
    case permissionError
    case locationError
    case currentNetworkError
    case forecastNetworkError
}
