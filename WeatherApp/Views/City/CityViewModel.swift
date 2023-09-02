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
    
    @Published var weather: Weather?
    
    private var location: CLLocationCoordinate2D? {
        didSet {
            guard let lat = location?.latitude, let lon = location?.longitude else { return }
            
            fetchWeatherData(lat: lat, lon: lon)
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
    
    func fetchWeatherData(lat: Double, lon: Double) {
        Task {
            do {
                let responseApiModel = try await currentWeatherAPI.fetchData(lat: lat, lon: lon, units: .metric)
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
