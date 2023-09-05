//
//  CityView.swift
//  weatherApp
//
//  Created by Erich.Flock on 01.09.23.
//

import SwiftUI
import CoreLocationUI

struct CityView: View {
    
    @ObservedObject var viewModel: CityViewModel = .init()
    
    var body: some View {
        NavigationView {
            VStack() {
                ZStack {
                    VStack {
                        if viewModel.isLoading {
                            ProgressView("Loading weather...")
                                .controlSize(.large)
                        } else if viewModel.deniedPermission {
                            deniedPermissionView
                        } else if viewModel.weather == nil {
                            noDataAvailableView
                        } else {
                            mainContent
                            temperatureUnitPicker
                        }
                    }
                    HStack {
                        Spacer()
                        locationButton
                            .padding(.trailing, 50)
                    }
                }
                .frame(height: 300)
                .padding(.top, 70)
                
                Spacer()
                
                searchButton
                    .padding(.bottom, 100)
            }
            .background(
                WeatherGradientView()
            )
            .navigationTitle("Weather")
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .center, spacing: 8) {
            if let cityName = viewModel.weather?.name {
                Text(cityName)
                    .font(.largeTitle)
            }
            if let actualTemperature = viewModel.format(temperature: viewModel.weather?.actualTemperature) {
                Text("\(actualTemperature)°")
                    .font(.system(size: 80))
            }
            VStack(spacing: 8) {
                if let imageName = viewModel.weather?.condition?.imageName {
                    Image(systemName: imageName)
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 30))
                }
                if let condition = viewModel.weather?.condition?.name {
                    Text(condition)
                        .font(.system(size: 20))
                }
                if let description = viewModel.weather?.description {
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
            }
            HStack {
                if let maxTemp = viewModel.format(temperature: viewModel.weather?.maxTemperature),
                   let minTemp = viewModel.format(temperature: viewModel.weather?.minTemperature) {
                    Text("H: \(maxTemp)°")
                    Text("L: \(minTemp)°")
                }
            }
        }
    }
    
    private var temperatureUnitPicker: some View {
        Picker("Unit", selection: $viewModel.temperatureUnit) {
            ForEach(TemperatureUnit.allCases, id: \.self) {
                Text($0.rawValue.capitalized)
            }
        }
        .frame(width: 200)
        .pickerStyle(.segmented)
    }
    
    private var locationButton: some View {
        LocationButton() {
            viewModel.requestLocation()
        }
        .cornerRadius(10)
        .labelStyle(.iconOnly)
        .foregroundColor(.white)
    }
    
    private var searchButton: some View {
        NavigationLink {
            SearchCityView(viewModel: .init(location: $viewModel.location))
        } label: {
            Text("Search City")
        }
        .controlSize(.large)
        .buttonStyle(.borderedProminent)        
    }
    
    private var deniedPermissionView: some View {
        VStack(spacing: 25) {
            Text("Sorry, we can only provide weather data if you allow us to use your location or if you search for a city.")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 110)
            Image(systemName: "globe.americas.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue)
                .font(.system(size: 50))
        }
        .padding(.bottom, 50)
    }
    
    private var noDataAvailableView: some View {
        VStack {
            VStack(spacing: 25) {
                Text("Sorry, no data available. Please try it again later")
                    .font(.system(size: 18))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 110)
                Image(systemName: "icloud.slash.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.blue)
                    .font(.system(size: 50))
            }
            .padding(.bottom, 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
