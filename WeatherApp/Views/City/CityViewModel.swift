//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import SwiftUI
import CoreLocation

final class CityViewModel: ObservableObject {
    
    @Published var temperatureUnit: TemperatureUnit = .celsius {
        didSet {
            fetchWeatherData()
        }
    }
    
    private let locationManager = LocationManager()
    private let currentWeatherAPI: CurrentWeatherAPIProtocol
    
    @Published var weather: Weather?
    
    private var location: CLLocationCoordinate2D? {
        didSet {
            fetchWeatherData()
        }
    }
    
    init(currentWeatherAPI: CurrentWeatherAPIProtocol = CurrentWeatherAPI()) {
        self.currentWeatherAPI = currentWeatherAPI
        locationManager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func fetchWeatherData() {
        guard let lat = location?.latitude, let lon = location?.longitude else { return }
        
        Task {
            do {
                let responseApiModel = try await currentWeatherAPI.fetchData(lat: lat, lon: lon, units: temperatureUnit.convertToApiUnit())
                DispatchQueue.main.async { [weak self] in
                    self?.weather = Weather.mapper(apiModel: responseApiModel)
                }
            } catch {
                //TODO: Display Error Alert
            }
        }
    }
    
    func format(temperature: Double?) -> String? {
        guard let temperature else { return nil }
        
        return String(format: "%.0f", temperature)
    }
    
}

extension CityViewModel: LocationManagerDelegate {
    
    func didUpdateLocation(location: CLLocationCoordinate2D?) {
        self.location = location
    }
    
    func didFailToUpdateLocationWithError(_ error: Error) {
        //TODO: Display alert with error
    }
    
}
