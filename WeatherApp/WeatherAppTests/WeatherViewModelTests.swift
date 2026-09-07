//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Erik Egers on 2026/08/26.
//

import Testing
import CoreLocation
@testable import WeatherApp

@MainActor
struct WeatherViewModelTests {

    // MARK: Helpers

    func makeViewModel(
        location: MockLocationManager = MockLocationManager(),
        service: MockWeatherClient = MockWeatherClient()) -> WeatherViewModel {
        WeatherViewModel(
            locationManager: location,
            weatherService: service,
            favouritesStore: MockFavouritesStore()
        )
    }

    // MARK: Tests

    @Test
    func initialStateIsIdle() {
        let viewModel = makeViewModel()

        #expect(viewModel.state == .idle)
        #expect(viewModel.currentWeather == nil)
        #expect(viewModel.fiveDayForecast.isEmpty)
    }

    @Test
    func successfulFetchLoadsWeather() async {
        let viewModel = makeViewModel()

        await viewModel.fetchWeather()

        guard case .loaded = viewModel.state else {
            Issue.record("Expected the view model to be loaded")
            return
        }

        #expect(viewModel.currentWeather?.current == 20)
        #expect(viewModel.currentWeather?.min == 12)
        #expect(viewModel.currentWeather?.max == 21)
        #expect(viewModel.currentWeather?.condition == .sunny)
        
        #expect(viewModel.fiveDayForecast.count == 5)

        #expect(viewModel.fiveDayForecast[0].temperature == 20)
        #expect(viewModel.fiveDayForecast[1].temperature == 19)
        #expect(viewModel.fiveDayForecast[2].temperature == 8)
        #expect(viewModel.fiveDayForecast[3].temperature == 14)
        #expect(viewModel.fiveDayForecast[4].temperature == 18)

        #expect(viewModel.fiveDayForecast.allSatisfy { $0.day != nil })
    }

    @Test
    func permissionFailureShowsFailedState() async {
        let location = MockLocationManager()
        location.permissionShouldSucceed = false

        let viewModel = makeViewModel(location: location)

        await viewModel.fetchWeather()

        guard case .failed(let message) = viewModel.state else {
            Issue.record("Expected the view model to be in a failed state")
            return
        }

        #expect(!message.isEmpty)
        #expect(viewModel.currentWeather == nil)
    }

    @Test
    func locationFailureShowsFailedState() async {
        let location = MockLocationManager()
        location.locationShouldSucceed = false

        let viewModel = makeViewModel(location: location)

        await viewModel.fetchWeather()

        guard case .failed(let message) = viewModel.state else {
            Issue.record("Expected the view model to be in a failed state")
            return
        }

        #expect(!message.isEmpty)
    }

    @Test
    func currentWeatherFailureShowsFailedState() async {
        let service = MockWeatherClient()
        service.getCurrentWeatherShouldSucceed = false

        let viewModel = makeViewModel(service: service)

        await viewModel.fetchWeather()

        guard case .failed(let message) = viewModel.state else {
            Issue.record("Expected the view model to be in a failed state")
            return
        }

        #expect(!message.isEmpty)
        #expect(viewModel.currentWeather == nil)
    }

    @Test
    func forecastFailureShowsFailedState() async {
        let service = MockWeatherClient()
        service.getWeatherForecastShouldSucceed = false

        let viewModel = makeViewModel(service: service)

        await viewModel.fetchWeather()

        guard case .failed(let message) = viewModel.state else {
            Issue.record("Expected the view model to be in a failed state")
            return
        }

        #expect(!message.isEmpty)
        #expect(viewModel.currentWeather == nil)
    }
}
