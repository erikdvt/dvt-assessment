//
//  MockFavouritesStore.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/09/04.
//



@MainActor
final class MockFavouritesStore: FavouritesStoreType {
    private(set) var favourites: [WeatherFavourite] = []

    func fetch() -> [WeatherFavourite] {
        favourites
    }

    func add(city: String, latitude: Double, longitude: Double) {
        favourites.append(WeatherFavourite(
            city: city,
            latitude: latitude,
            longitude: longitude
        ))
    }

    func delete(_ favourite: WeatherFavourite) {
        favourites.removeAll { $0 === favourite }
    }
}
