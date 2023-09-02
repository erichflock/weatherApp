//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(location: CLLocationCoordinate2D?)
    func didFailToUpdateLocationWithError(_ error: Error)
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default:
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(location: locations.first?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didFailToUpdateLocationWithError(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
         requestLocation()
    }
}
