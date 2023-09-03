//
//  APIError.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

enum APIError: Error {
    case invalidUrl
    case decodeError
    case fetchError
}
