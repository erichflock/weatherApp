//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(location: CLLocationCoordinate2D?)
}

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.didUpdateLocation(location: locations.first?.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: handle error
    }
}
