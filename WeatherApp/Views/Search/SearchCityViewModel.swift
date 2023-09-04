//
//  SearchCityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI

final class SearchCityViewModel: ObservableObject {
    
    @Published var searchedCity: String = ""
    @Published var cities: [City] = []
    
    private let geoCodingAPI: GeoCodingAPIProtocol
    
    init(geoCodingAPI: GeoCodingAPIProtocol = GeoCodingAPI()) {
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
        
        return [city.name, city.country, city.state].compactMap { $0 }.joined(separator: ", ")
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
}
