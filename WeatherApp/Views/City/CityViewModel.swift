//
//  CityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import SwiftUI
import CoreLocation

class CityViewModel: ObservableObject {
    
    @Published var temperatureUnit: TemperatureUnit = .celsius {
        didSet {
            Task {
                await fetchWeatherData()
            }
        }
    }
    
    private let locationManager = LocationManager()
    private let currentWeatherAPI: CurrentWeatherAPIProtocol
    
    @Published var weather: Weather?
    @Published var isLoading = false
    @Published var deniedPermission = false
    
    @Published var location: CLLocationCoordinate2D? {
        didSet {
            Task {
                await fetchWeatherData()
            }
        }
    }
    
    init(currentWeatherAPI: CurrentWeatherAPIProtocol = CurrentWeatherAPI()) {
        self.currentWeatherAPI = currentWeatherAPI
        locationManager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
        setLoading(true)
        locationManager.requestLocation()
    }
    
    func fetchWeatherData() async {
        guard let lat = location?.latitude, let lon = location?.longitude else { return }
    
        setLoading(true)
        
        do {
            let responseApiModel = try await currentWeatherAPI.fetchData(lat: lat, lon: lon, units: temperatureUnit.convertToApiUnit())
            DispatchQueue.main.async { [weak self] in
                self?.weather = Weather.mapper(apiModel: responseApiModel)
                self?.setLoading(false)
            }
        } catch {
            setLoading(false)
        }
    }
    
    func format(temperature: Double?) -> String? {
        guard let temperature else { return nil }
        
        return String(format: "%.0f", temperature)
    }
    
    private func setLoading(_ isLoading: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = isLoading
        }
    }
    
}

extension CityViewModel: LocationManagerDelegate {
    
    func didUpdateLocation(location: CLLocationCoordinate2D?) {
        deniedPermission = false
        self.location = location
    }
    
    func didFailToUpdateLocationWithError(_ error: Error) {
        setLoading(false)
    }
    
    func didDeniedPermission() {
        setLoading(false)
        deniedPermission = true
    }
    
}
