//
//  WeatherFavourite.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import Foundation
import SwiftData

@MainActor
protocol FavouritesStoreType {
    func fetch() -> [WeatherFavourite]
    func add(city: String, latitude: Double, longitude: Double)
    func delete(_ favourite: WeatherFavourite)
}

@MainActor
final class FavouritesStore: FavouritesStoreType {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetch() -> [WeatherFavourite] {
        (try? modelContext.fetch(FetchDescriptor<WeatherFavourite>())) ?? []
    }

    func add(city: String, latitude: Double, longitude: Double) {
        modelContext.insert(WeatherFavourite(
            city: city,
            latitude: latitude,
            longitude: longitude))
        try? modelContext.save()
    }

    func delete(_ favourite: WeatherFavourite) {
        modelContext.delete(favourite)
        try? modelContext.save()
    }
}

@Model
final class WeatherFavourite {
    var city: String
    var latitude: Double
    var longitude: Double
    
    init(city: String,
         latitude: Double,
         longitude: Double) {
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
    }
}
