//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import SwiftUI

final class CityViewModel: ObservableObject {
    
    enum TemperatureUnit: String, CaseIterable {
        case celsius
        case fahrenheit
    }
    
    @State var temperatureUnit: TemperatureUnit = .celsius
    
}
