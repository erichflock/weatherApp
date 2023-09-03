//
//  City.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

struct City {
    var name: String?
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?
}

//MARK: Mapper
extension City {
    
    static func mapper(apiCities: [GeoCodingCityAPIModel]?) -> [City]? {
        guard let apiCities, !apiCities.isEmpty else { return nil }
        
        return apiCities.map( { .init(name: $0.name,
                                      lat: $0.lat,
                                      lon: $0.lon,
                                      country: $0.country,
                                      state: $0.state)
        } )
    }
    
}
