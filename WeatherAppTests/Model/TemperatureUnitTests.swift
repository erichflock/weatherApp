//
//  TemperatureUnitTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 02.09.23.
//

import XCTest
@testable import WeatherApp

final class TemperatureUnitTests: XCTestCase {

    func test_convertToApiUnit_whenCelsius_shouldReturnMetric() {
        let sut: TemperatureUnit = .celsius
        
        XCTAssertEqual(sut.convertToApiUnit(), .metric)
    }
    
    func test_convertToApiUnit_whenFahrenheit_shouldReturnImperial() {
        let sut: TemperatureUnit = .fahrenheit
        
        XCTAssertEqual(sut.convertToApiUnit(), .imperial)
    }

}
