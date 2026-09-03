//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Erik Egers on 2026/08/26.
//

import SwiftUI
import SwiftData

struct WeatherView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject var viewModel: WeatherViewModel
    
    var body: some View {
        let portraitHeight = max(
            UIScreen.main.bounds.width,
            UIScreen.main.bounds.height
        )
        
        ScrollView {
            VStack(spacing: 0) {
                VStack {
                    Spacer()
                    
                    Text("\(viewModel.currentWeather?.current ?? 0)°")
                        .font(.system(size: 72, weight: .bold))
                    
                    Text(viewModel.currentWeather?.condition?.displayName.uppercased() ?? "")
                        .font(.title2)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: portraitHeight * 0.5)
                .background {
                    Image(viewModel.currentWeather?.condition?.backgroundImage ?? "")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    if let currentWeather = viewModel.currentWeather {
                        CurrentWeatherRow(weatherForecast: currentWeather)
                    }
                    
                    Rectangle()
                        .fill(.white)
                        .frame(height: 1)
                        .padding(.horizontal, -16)
                    
                    VStack(spacing: 0) {
                        ForEach(viewModel.fiveDayForecast.indices, id: \.self) { index in
                            WeatherForecastRow(weatherForecast: viewModel.fiveDayForecast[index])
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .foregroundStyle(.white)
        .background {
            Color(viewModel.currentWeather?.condition?.backgroundColor ?? "")
                .ignoresSafeArea()
        }
        .task { await viewModel.fetchWeather()}
    }
}

// MARK: - Current Weather Row

struct CurrentWeatherRow: View {
    
    let weatherForecast: CurrentWeather
    
    var body: some View {
        VStack {
            HStack {
                Text("\(weatherForecast.min ?? 0)°")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("\(weatherForecast.current ?? 0)°")
                
                Text("\(weatherForecast.max ?? 0)°")
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
            Text(weatherForecast.day ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(weatherForecast.condition?.weatherIcon ?? "")
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
            
            Text("\(weatherForecast.temperature ?? 0)°")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

#Preview {
    WeatherView(viewModel: WeatherViewModel(locationManager: LocationManager(), weatherService: OpenWeatherMapAPIClient()))
        .modelContainer(for: Item.self, inMemory: true)
}
