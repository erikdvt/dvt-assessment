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

enum WeatherViewState: Equatable {
    case idle
    case loading
    case loaded
    case failed(String)
}

@MainActor
final class WeatherViewModel: ObservableObject {
    
    @Published private(set) var state: WeatherViewState = .idle
    @Published var fiveDayForecast: [WeatherForecast] = []
    @Published var currentWeather: CurrentWeather?
    
    private let locationManager: LocationManagerType
    private let weatherService: WeatherClientType
    
    init(locationManager: LocationManagerType,
         weatherService: WeatherClientType) {
        self.locationManager = locationManager
        self.weatherService = weatherService
    }
    
    var lastUpdated: String {
        guard let timestamp = currentWeather?.lastUpdated else { return "" }
        return "Last updated: " + timestamp.formattedValue
    }
    
    func fetchWeather(coordinates: CLLocationCoordinate2D? = nil) async {
        state = .loading
        do {
            var weatherCoordinates = CLLocationCoordinate2D()
            
            if let coordinates {
                weatherCoordinates = coordinates
            } else {
                try await locationManager.requestLocationPermission()
                weatherCoordinates = try await locationManager.getCurrentLocation()
            }
            
            let current = try await weatherService.getCurrentWeather(coordinates: weatherCoordinates)
            let forecast = try await weatherService.getFiveDayWeatherForecast(coordinates: weatherCoordinates)
            
            currentWeather = CurrentWeather(response: current)
            fiveDayForecast = makeForecasts(responses: forecast.list)
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
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
