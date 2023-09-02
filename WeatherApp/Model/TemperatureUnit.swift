//
//  TemperatureUnit.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

enum TemperatureUnit: String, CaseIterable {
    case celsius
    case fahrenheit
}

extension TemperatureUnit {
    
    func convertToApiUnit() -> CurrentWeatherAPIUnit {
        switch self {
        case .celsius:
            return .metric
        case .fahrenheit:
            return .imperial
        }
    }
    
}
