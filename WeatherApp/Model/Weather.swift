//
//  Weather.swift
//  WeatherApp
//
//  Created by Erich.Flock on 02.09.23.
//

struct Weather {
    
    var condition: Condition?
    var description: String?
    var actualTemperature: Double?
    var maxTemperature: Double?
    var minTemperature: Double?
    
    enum Condition: String, Decodable {
        case thunderstorm
        case drizzle
        case rain
        case snow
        case mist
        case smoke
        case haze
        case dust
        case fog
        case sand
        case ash
        case squall
        case tornado
        case clear
        case clouds
        
        var imageName: String {
            switch self {
            case .rain, .drizzle:
                return "cloud.rain.fill"
            case .snow:
                return "snowflake.circle.fill"
            case .fog, .haze, .mist:
                return "cloud.fog.fill"
            case .ash, .smoke, .sand, .dust:
                return "smoke.fill"
            case .squall, .thunderstorm:
                return "cloud.bolt.rain.fill"
            case .tornado:
                return "tornado"
            case .clear:
                return "sun.max.fill"
            case .clouds:
                return "cloud.fill"
            }
        }
    }
}
