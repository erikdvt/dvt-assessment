//
//  ContentView.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    let fiveDayForecast = [
        WeatherForecast(day: "Monday", condition: .sunny, temperature: 22),
        WeatherForecast(day: "Tuesday", condition: .cloudy, temperature: 17),
        WeatherForecast(day: "Wednesday", condition: .rainy, temperature: 10),
        WeatherForecast(day: "Thursday", condition: .sunny, temperature: 25),
        WeatherForecast(day: "Friday", condition: .sunny, temperature: 21)
    ]
    
    let currentWeather = CurrentWeather(condition: .cloudy, min: 12, current: 15, max: 18)
    
    var body: some View {
        let portraitHeight = max(
            UIScreen.main.bounds.width,
            UIScreen.main.bounds.height
        )
        
        ScrollView {
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    
                    Text("\(currentWeather.current)°")
                        .font(.system(size: 72, weight: .bold))
                    
                    Text(currentWeather.condition.displayName.uppercased())
                        .font(.title2)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: portraitHeight * 0.5)
                .background {
                    Image(currentWeather.condition.backgroundImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    CurrentWeatherRow(weatherForecast: currentWeather)
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 1)
                        .padding(.horizontal, -16)
                    
                    VStack(spacing: 0) {
                        ForEach(fiveDayForecast.indices, id: \.self) { index in
                            WeatherForecastRow(weatherForecast: fiveDayForecast[index])
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
        .foregroundStyle(.white)
        .background {
            Color(currentWeather.condition.backgroundColor)
                .ignoresSafeArea()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

// MARK: - Current Weather Row

struct CurrentWeatherRow: View {
    
    let weatherForecast: CurrentWeather
    
    var body: some View {
        VStack {
            HStack {
                Text("\(weatherForecast.min)°")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(weatherForecast.current)°")
                
                Text("\(weatherForecast.max)°")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                Text("Min")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("Current")
                
                Text("Max")
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

// MARK: - Weather Forecast Row

struct WeatherForecastRow: View {
    
    let weatherForecast: WeatherForecast
    
    var body: some View {
        HStack {
            Text(weatherForecast.day)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(weatherForecast.condition.weatherIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            Text("\(weatherForecast.temperature)°")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

// MARK: - Models

enum WeatherCondition {
    case sunny
    case cloudy
    case rainy
    
    var displayName: String {
        switch self {
        case .sunny:
            return "Sunny"
        case .cloudy:
            return "Cloudy"
        case .rainy:
            return "Rainy"
        }
    }
    
    var weatherIcon: String {
        switch self {
        case .sunny:
            return "sunnyIcon"
        case .cloudy:
            return "cloudyIcon"
        case .rainy:
            return "rainyIcon"
        }
    }
    
    var backgroundImage: String {
        switch self {
        case .sunny:
            return "sunnyBackground"
        case .cloudy:
            return "cloudyBackground"
        case .rainy:
            return "rainyBackground"
        }
    }
    
    var backgroundColor: String {
        switch self {
        case .sunny:
            return "sunny"
        case .cloudy:
            return "cloudy"
        case .rainy:
            return "rainy"
        }
    }
}

struct WeatherForecast {
    var day: String
    var condition: WeatherCondition
    var temperature: Int
}

struct CurrentWeather {
    var condition: WeatherCondition
    var min: Int
    var current: Int
    var max: Int
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
