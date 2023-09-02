//
//  CurrentWeatherAPI.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

import Foundation

enum CurrentWeatherAPIError: Error {
    case invalidUrl
    case decodeError
    case fetchError
}

protocol URLSessionProtocol {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

class CurrentWeatherAPI {
    
    let API_KEY = ""
    
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func fetchData(lat: Double, lon: Double, baseUrl: String = "https://api.openweathermap.org/data/2.5/weather") async throws -> CurrentWeatherAPIResponseModel? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [.init(name: "lat", value: lat.description),
                                     .init(name: "lon", value: lon.description),
                                     .init(name: "appid", value: API_KEY)]
        guard let url = urlComponents?.url else { throw CurrentWeatherAPIError.invalidUrl }
        
        do {
            let (data, _) = try await urlSession.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseModel = try decoder.decode(CurrentWeatherAPIResponseModel.self, from: data)
            return responseModel
        } catch(let error) {
            throw CurrentWeatherAPIError.decodeError
        }
    }
    
}

struct CurrentWeatherAPIResponseModel: Decodable {
    
    var coord: Coordinate?
    var weather: [Weather]?
    var main: WeatherInformation?
    
    struct Coordinate: Decodable {
        var lon: Double?
        var lat: Double?
    }
    
    struct Weather: Decodable {
        var id: Int?
        var main: WeatherCondition?
        var description: String?
        
        enum WeatherCondition: String, Decodable {
            case Thunderstorm
            case Drizzle
            case Rain
            case Snow
            case Mist
            case Smoke
            case Haze
            case Dust
            case Fog
            case Sand
            case Ash
            case Squall
            case Tornado
            case Clear
            case Clouds
        }
    }
    
    struct WeatherInformation: Decodable {
        var temp: Double?
        var tempMin: Double?
        var tempMax: Double?
    }
    
}
