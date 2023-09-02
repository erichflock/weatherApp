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

enum CurrentWeatherAPIUnit: String {
    case metric //celsius
    case imperial //fahrenheit
}

protocol CurrentWeatherAPIProtocol: AnyObject {
    func fetchData(lat: Double, lon: Double, units: CurrentWeatherAPIUnit) async throws -> CurrentWeatherAPIResponseModel?
}

protocol URLSessionProtocol: AnyObject {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class CurrentWeatherAPI: CurrentWeatherAPIProtocol {
    
    private let API_KEY = ""
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather"
    
    var urlSession: URLSessionProtocol = URLSession.shared
    
    func fetchData(lat: Double, lon: Double, units: CurrentWeatherAPIUnit = .metric) async throws -> CurrentWeatherAPIResponseModel? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = [.init(name: "lat", value: lat.description),
                                     .init(name: "lon", value: lon.description),
                                     .init(name: "units", value: units.rawValue),
                                     .init(name: "appid", value: API_KEY)]
        guard let url = urlComponents?.url else { throw CurrentWeatherAPIError.invalidUrl }
        
        do {
            let (data, _) = try await urlSession.data(from: url, delegate: nil)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let responseModel = try decoder.decode(CurrentWeatherAPIResponseModel.self, from: data)
            return responseModel
        } catch {
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
