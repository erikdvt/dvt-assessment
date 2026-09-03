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
    @Published var fiveDayForecast: [WeatherForecast] = []
    @Published var currentWeather: CurrentWeather?
    
    private let locationManager: LocationManagerType
    private let weatherService: OpenWeatherMapClient
    
    init(locationManager: LocationManagerType,
         weatherService: OpenWeatherMapClient) {
        self.locationManager = locationManager
        self.weatherService = weatherService
    }
    
    func fetchWeather() async {
        do {
            try await locationManager.requestLocationPermission()
            let coordinates = try await locationManager.getCurrentLocation()
            
            let current = try await weatherService.getCurrentWeather(coordinates: coordinates)
            let forecast = try await weatherService.getFiveDayWeatherForecast(coordinates: coordinates)
            
            currentWeather = CurrentWeather(response: current)
            fiveDayForecast = makeForecasts(responses: forecast.list)
        } catch {
            errorMessage = "Failed to get your location.\nPlease try again later."
            showError = true
            print("Failed to get location: \(error)")
        }
    }
    
    private func makeForecasts(responses: [List]) -> [WeatherForecast] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let groupedByDay = Dictionary(grouping: responses) { response in
            guard let timestamp = response.dt else {
                return Date.distantPast
            }
            
            return calendar.startOfDay(
                for: Date(timeIntervalSince1970: TimeInterval(timestamp))
            )
        }
        
        return groupedByDay
            .filter { date, _ in
                date != Date.distantPast && date > today
            }
            .sorted { $0.key < $1.key }
            .compactMap { date, forecasts in
                guard let maxForecast = forecasts.max(by: {
                    ($0.main?.temp ?? -.infinity) < ($1.main?.temp ?? -.infinity)
                }) else {
                    return nil
                }
                
                let weekday = calendar.component(.weekday, from: date)
                let day = calendar.weekdaySymbols[weekday - 1]
                
                return WeatherForecast(
                    response: maxForecast,
                    day: day
                )
            }
    }
}
