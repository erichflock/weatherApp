//
//  SearchCityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI
import CoreLocation

final class SearchCityViewModel: ObservableObject {
    
    @Published var searchedCity: String = ""
    @Published var cities: [City] = []
    @Binding private(set) var location: CLLocationCoordinate2D?
    
    private let geoCodingAPI: GeoCodingAPIProtocol
    
    init(location: Binding<CLLocationCoordinate2D?>, geoCodingAPI: GeoCodingAPIProtocol = GeoCodingAPI()) {
        self._location = location
        self.geoCodingAPI = geoCodingAPI
    }
    
    func fetchCities() async {
        guard !searchedCity.isEmpty else { return }
        do {
            let apiCities = try await geoCodingAPI.getCities(for: self.searchedCity, limit: 5)
            update(cities: City.mapper(apiCities: apiCities))
        } catch {
            update(cities: nil)
        }
    }
    
    func clearCities() {
        update(cities: nil)
    }
    
    func createTitle(for city: City) -> String? {
        guard let cityName = city.name else { return nil }
        
        return [cityName, city.country, city.state].compactMap { $0 }.joined(separator: ", ")
    }
    
    private func update(cities: [City]?) {
        guard let cities else {
            self.cities = []
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.cities = cities
        }
    }
    
    func didSelect(city: City) {
        guard let cityLat = city.lat, let cityLon = city.lon else { return }
        
        location = .init(latitude: cityLat, longitude: cityLon)
    }
}
