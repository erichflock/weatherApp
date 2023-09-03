//
//  WeatherTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 02.09.23.
//

import XCTest
@testable import WeatherApp

final class WeatherTests: XCTestCase {
    
    func test_mapper_whenApiModelAvailable_shouldMapValuesCorrectly() {
        var apiModel = CurrentWeatherAPIResponseModel(weather: [.init(main: .Fog, description: "it's foggy")],
                                                      main: .init(temp: 20.0, tempMin: 10.0, tempMax: 30.0),
                                                      name: "Berlin")
        
        var sut = Weather.mapper(apiModel: apiModel)
        
        XCTAssertEqual(sut?.name, "Berlin")
        XCTAssertEqual(sut?.condition, .fog)
        XCTAssertEqual(sut?.description, "it's foggy")
        XCTAssertEqual(sut?.actualTemperature, 20.0)
        XCTAssertEqual(sut?.minTemperature, 10.0)
        XCTAssertEqual(sut?.maxTemperature, 30.0)
        
        apiModel = CurrentWeatherAPIResponseModel(weather: [.init(main: .Clear, description: "it's sunny")],
                                                      main: .init(temp: 35.5, tempMin: 30.0, tempMax: 40.0),
                                                      name: "London")
        
        sut = Weather.mapper(apiModel: apiModel)
        
        XCTAssertEqual(sut?.name, "London")
        XCTAssertEqual(sut?.condition, .clear)
        XCTAssertEqual(sut?.description, "it's sunny")
        XCTAssertEqual(sut?.actualTemperature, 35.5)
        XCTAssertEqual(sut?.minTemperature, 30.0)
        XCTAssertEqual(sut?.maxTemperature, 40.0)

    }
    
    func test_mapper_whenApiModelNotAvailable_shouldReturnNil() {
        let sut = Weather.mapper(apiModel: nil)
        
        XCTAssertNil(sut)
    }
    
}
