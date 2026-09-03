//
//  MockWeatherClient.swift
//  WeatherAppTests
//
//  Created by Erik Egers on 2026/09/03.
//

import Foundation
import CoreLocation
@testable import WeatherApp

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
        if getWeatherForecastShouldSucceed {
            return WeatherForecastResponse(
                cod: nil,
                message: nil,
                cnt: nil,
                list: [
                    List(
                        dt: nil,
                        main: Main(temp: 20.0, feelsLike: nil, tempMin: 12.0, tempMax: 21.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil),
                    List(
                        dt: nil,
                        main: Main(temp: 19.0, feelsLike: nil, tempMin: 11.0, tempMax: 22.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil),
                    List(
                        dt: nil,
                        main: Main(temp: 8.0, feelsLike: nil, tempMin: 16.0, tempMax: 28.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil),
                    List(
                        dt: nil,
                        main: Main(temp: 14.0, feelsLike: nil, tempMin: 26.0, tempMax: 30.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil),
                    List(
                        dt: nil,
                        main: Main(temp: 18.0, feelsLike: nil, tempMin: 29.0, tempMax: 35.0, pressure: nil, humidity: nil, seaLevel: nil, grndLevel: nil),
                        weather: [],
                        clouds: nil,
                        wind: nil,
                        visibility: nil,
                        pop: nil,
                        rain: nil,
                        sys: nil,
                        dtTxt: nil),
                ],
                city: nil)
            
        } else {
            throw MockError.forecastNetworkError
        }
    }
