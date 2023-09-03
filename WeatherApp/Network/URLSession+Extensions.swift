//
//  URLSession+Extensions.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import Foundation

protocol URLSessionProtocol: AnyObject {
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}
