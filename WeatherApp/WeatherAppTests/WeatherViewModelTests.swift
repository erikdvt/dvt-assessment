//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Erik Egers on 2026/08/26.
//

import Testing
import CoreLocation
@testable import WeatherApp

enum MockError: Error {
    case permissionError
    case locationError
    case currentNetworkError
    case forecastNetworkError
}

struct WeatherViewModelTests {
    
    // MARK: Helpers
    
    @MainActor func makeViewModel(location: LocationManagerType = MockLocationManager(),
                                  service: WeatherClientType = MockWeatherClient()) -> WeatherViewModel {
        WeatherViewModel(locationManager: location,
                         weatherService: service)
    }
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

}


