//
//  CityViewModelTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 04.09.23.
//

import XCTest
@testable import WeatherApp

final class CityViewModelTests: XCTestCase {

    func test_temperatureUnit_whenChanged_shouldFetchWeatherData() {
        let sut = CityViewModelSpy(currentWeatherAPI: CurrentWeatherAPISpy())
        XCTAssertEqual(sut.temperatureUnit, .celsius, "precondition")
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 0, "precondition")
        
        sut.temperatureUnit = .fahrenheit
        
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 1)
    }
    
    func test_location_whenChanged_shouldFetchWeatherData() {
        let sut = CityViewModelSpy(currentWeatherAPI: CurrentWeatherAPISpy())
        XCTAssertNil(sut.location)
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 0)
        
        sut.location = .init(latitude: 10, longitude: -10)
        
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 1)
    }
    
}

//MARK: Helpers
extension CityViewModelTests {
    
    func makeSUT(currentWeatherAPI: CurrentWeatherAPIProtocol = CurrentWeatherAPISpy()) -> CityViewModel {
        .init(currentWeatherAPI: currentWeatherAPI)
    }
    
}

private class CurrentWeatherAPISpy: CurrentWeatherAPIProtocol {
    
    private(set) var fetchDataCallCount = 0
    private(set) var units: CurrentWeatherAPIUnit?
    
    func fetchData(lat: Double, lon: Double, units: WeatherApp.CurrentWeatherAPIUnit) async throws -> WeatherApp.CurrentWeatherAPIResponseModel? {
        fetchDataCallCount += 1
        self.units = units
        return nil
    }
    
}

private class CityViewModelSpy: CityViewModel {
    
    private(set) var fetchWeatherDataCallCount = 0
    
    override func fetchWeatherData() {
        fetchWeatherDataCallCount += 1
    }
    
}
