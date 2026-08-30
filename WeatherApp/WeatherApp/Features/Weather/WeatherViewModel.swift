//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/30.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    
    private let locationManager: LocationManagerType
    
    init(locationManager: LocationManagerType) {
        self.locationManager = locationManager
    }
    
    var fiveDayForecast: [WeatherForecast] {
        return [
            WeatherForecast(day: "Monday", condition: .sunny, temperature: 22),
            WeatherForecast(day: "Tuesday", condition: .cloudy, temperature: 17),
            WeatherForecast(day: "Wednesday", condition: .rainy, temperature: 10),
            WeatherForecast(day: "Thursday", condition: .sunny, temperature: 25),
            WeatherForecast(day: "Friday", condition: .sunny, temperature: 21)
        ]
    }
    
    var currentWeather: CurrentWeather {
        return CurrentWeather(condition: .cloudy, min: 12, current: 15, max: 18)
    }
    
    func fetchWeather() async {
        do {
            try await locationManager.requestLocationPermission()

            let coords = try await locationManager.getCurrentLocation()

            print(coords)
        } catch {
            errorMessage = "Failed to get your location.\nPlease try again later."
            showError = true
            print("Failed to get location: \(error)")
        }
    }
}
