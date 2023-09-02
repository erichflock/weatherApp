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
            
            VStack(spacing: 20) {
                searchButton
            }
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Leipzig")
                    .font(.largeTitle)
                Text("30°")
                    .font(.system(size: 80))
            }
            HStack {
                VStack {
                    Text("Rain")
                        .font(.system(size: 20))
                    Text("moderate rain")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                Image(systemName: "cloud.rain.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.gray, .blue)
                    .font(.system(size: 20))
            }
            HStack {
                Text("H: 20°")
                Text("L: 10°")
            }
        }
    }
    
    private var temperatureUnitPicker: some View {
        Picker("Temperature Unit", selection: $viewModel.temperatureUnit) {
            ForEach(CityViewModel.TemperatureUnit.allCases, id: \.self) {
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
