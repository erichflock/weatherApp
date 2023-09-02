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
        VStack(spacing: 100) {
            ZStack {
                VStack {
                    mainContent
                    temperatureUnitPicker
                }
                HStack {
                    Spacer()
                    locationButton
                        .padding(.trailing, 50)
                }
            }
            searchButton
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
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.gray, .blue)
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
        .pickerStyle(.menu)
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
        Button("Search City", action: {
            
        })
        .controlSize(.large)
        .buttonStyle(.borderedProminent)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
