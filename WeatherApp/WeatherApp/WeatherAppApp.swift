//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import SwiftUI
import SwiftData
import GooglePlacesSwift
import GoogleMaps

@main
struct WeatherAppApp: App {
    init() {
        let apiKey = "AIzaSyBk30kb8UXZwJsdxsBuzsQaO6f8iKhZGTA"
        _ = PlacesClient.provideAPIKey(apiKey)
        _ = GMSServices.provideAPIKey(apiKey)
    }

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WeatherFavourite.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                WeatherView(viewModel: WeatherViewModel(
                    locationManager: LocationManager(),
                    weatherService: WeatherClient(),
                    favouritesStore: FavouritesStore(
                        modelContext: sharedModelContainer.mainContext
                    )
                ))
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
