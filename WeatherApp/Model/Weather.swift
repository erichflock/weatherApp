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
    var name: String?
    
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
        
        var name: String {
            self.rawValue.capitalized
        }
    }
}

//MARK: Mapper
extension Weather {
    
    static func mapper(apiModel: CurrentWeatherAPIResponseModel?) -> Weather? {
        guard let apiModel else { return nil }

        return .init(condition: mapCondition(apiModel.weather?.first?.main),
                     description: apiModel.weather?.first?.description,
                     actualTemperature: apiModel.main?.temp,
                     maxTemperature: apiModel.main?.tempMax,
                     minTemperature: apiModel.main?.tempMin,
                     name: apiModel.name)
    }
    
    static private func mapCondition(_ apiCondition: CurrentWeatherAPIResponseModel.Weather.WeatherCondition?) -> Condition? {
        guard let apiCondition else { return nil }
        
        switch apiCondition {
        case .Thunderstorm:
            return .thunderstorm
        case .Drizzle:
            return .drizzle
        case .Rain:
            return .rain
        case .Snow:
            return .snow
        case .Mist:
            return .mist
        case .Smoke:
            return .smoke
        case .Haze:
            return .haze
        case .Dust:
            return .dust
        case .Fog:
            return .fog
        case .Sand:
            return .sand
        case .Ash:
            return .ash
        case .Squall:
            return .squall
        case .Tornado:
            return .tornado
        case .Clear:
            return .clear
        case .Clouds:
            return .clouds
        }
    }
    
}
