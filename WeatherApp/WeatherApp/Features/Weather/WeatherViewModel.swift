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
    @Published private(set) var fiveDayForecast: [WeatherForecast] = []
    @Published private(set) var currentWeather: CurrentWeather?
    @Published private(set) var currentCoordinates: CLLocationCoordinate2D?
    @Published private(set) var favourites: [WeatherFavourite] = []
    @Published var showingLocationPicker: Bool = false
    
    private let locationManager: LocationManagerType
    private let weatherService: WeatherClientType
    private let favouritesStore: FavouritesStoreType
    
    init(locationManager: LocationManagerType,
         weatherService: WeatherClientType,
         favouritesStore: FavouritesStoreType) {
        self.locationManager = locationManager
        self.weatherService = weatherService
        self.favouritesStore = favouritesStore
        loadFavourites()
    }

    func toggleFavourite() {
        guard let city = currentWeather?.city,
              let coordinates = currentCoordinates else { return }

        if let favourite = favourites.first(where: { $0.city == city }) {
            favouritesStore.delete(favourite)
        } else {
            favouritesStore.add(
                city: city,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude
            )
        }

        loadFavourites()
    }

    func deleteFavourite(_ favourite: WeatherFavourite) {
        favouritesStore.delete(favourite)
        loadFavourites()
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
            
            currentCoordinates = weatherCoordinates
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

    private func loadFavourites() {
        favourites = favouritesStore.fetch()
    }
}
