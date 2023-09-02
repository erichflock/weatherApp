//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import SwiftUI
import CoreLocation

final class CityViewModel: ObservableObject {
    
    enum TemperatureUnit: String, CaseIterable {
        case celsius
        case fahrenheit
    }
    
    @State var temperatureUnit: TemperatureUnit = .celsius
    
    private let locationManager = LocationManager()
    private let currentWeatherAPI: CurrentWeatherAPIProtocol
    
    init(currentWeatherAPI: CurrentWeatherAPIProtocol = CurrentWeatherAPI()) {
        self.currentWeatherAPI = currentWeatherAPI
        locationManager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
}

extension CityViewModel: LocationManagerDelegate {
    
    func didUpdateLocation(location: CLLocationCoordinate2D?) {
        guard let lat = location?.latitude, let lon = location?.longitude else { return }
        
        Task {
            do {
                let responseApiModel = try await currentWeatherAPI.fetchData(lat: lat, lon: lon, units: .metric)
                print(responseApiModel)
            } catch {
                //TODO: Display Error Alert
            }
        }
    }
    
    func didFailToUpdateLocationWithError(_ error: Error) {
        //TODO: Display alert with error
    }
    
}
