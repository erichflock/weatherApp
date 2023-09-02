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
    
    init() {
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
}

extension CityViewModel: LocationManagerDelegate {
    
    func didUpdateLocation(location: CLLocationCoordinate2D?) {
        print(location)
    }
    
}
