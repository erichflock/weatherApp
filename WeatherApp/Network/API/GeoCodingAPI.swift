//
//  GeoCodingAPI.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import Foundation

class GeoCodingAPI {
    
    private let baseUrl = "http://api.openweathermap.org/geo/1.0/direct"
    
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func getCities(for city: String, limit: Int = 5) async throws -> [GeoCodingCity]? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [.init(name: "q", value: city),
                                     .init(name: "limit", value: limit.description),
                                     .init(name: "appid", value: NetworkConfig.API_KEY)]
        guard let url = urlComponents?.url else { throw APIError.invalidUrl }
        
        do {
            let (data, _) = try await urlSession.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            let geoCodingCities = try decoder.decode([GeoCodingCity].self, from: data)
            return geoCodingCities
        } catch {
            throw APIError.decodeError
        }
    }
    
}

struct GeoCodingCity: Decodable {
    var name: String?
    var lat: Double?
    var lon: Double?
    var country: String?
    var state: String?
}