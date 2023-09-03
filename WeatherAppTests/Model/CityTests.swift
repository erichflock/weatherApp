//
//  CityTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 03.09.23.
//

import XCTest
@testable import WeatherApp

final class CityTests: XCTestCase {

    func test_mapperApiCities_whenApiCitiesNil_shouldReturnNil() {
        let cities = City.mapper(apiCities: nil)
        
        XCTAssertNil(cities)
    }
    
    func test_mapperApiCities_whenApiCitiesEmpty_shouldReturnNil() {
        let cities = City.mapper(apiCities: [])
        
        XCTAssertNil(cities)
    }
    
    func test_mapperApiCities_whenApiCitiesAvailable_shouldMapCitiesCorrectly() {
        let apiCities: [GeoCodingCityAPIModel] = [.init(name: "London", lat: 10, lon: -10, country: "GB", state: "England"),
                                                  .init(name: "City of London", lat: 20, lon: -20, country: "GB", state: "England"),
                                                  .init(name: "London", lat: 100, lon: -100, country: "CA", state: "Ontario")]
        
        let cities = City.mapper(apiCities: apiCities)
        
        XCTAssertEqual(cities?.count, 3)
        
        XCTAssertEqual(cities?[0].name, "London")
        XCTAssertEqual(cities?[0].lat, 10)
        XCTAssertEqual(cities?[0].lon, -10)
        XCTAssertEqual(cities?[0].country, "GB")
        XCTAssertEqual(cities?[0].state, "England")
        
        XCTAssertEqual(cities?[1].name, "City of London")
        XCTAssertEqual(cities?[1].lat, 20)
        XCTAssertEqual(cities?[1].lon, -20)
        XCTAssertEqual(cities?[1].country, "GB")
        XCTAssertEqual(cities?[1].state, "England")
        
        XCTAssertEqual(cities?[2].name, "London")
        XCTAssertEqual(cities?[2].lat, 100)
        XCTAssertEqual(cities?[2].lon, -100)
        XCTAssertEqual(cities?[2].country, "CA")
        XCTAssertEqual(cities?[2].state, "Ontario")
    }
    
}
