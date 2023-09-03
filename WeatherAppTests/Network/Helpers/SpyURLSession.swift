//
//  SpyURLSession.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 03.09.23.
//

import Foundation
@testable import WeatherApp

final class SpyURLSession: URLSessionProtocol {
    
    let jsonData: Data
    
    init(jsonData: Data) {
        self.jsonData = jsonData
    }
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        (jsonData, .init())
    }
    
}
