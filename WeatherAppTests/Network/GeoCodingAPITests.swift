//
//  GeoCodingAPITests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 03.09.23.
//

import XCTest
@testable import WeatherApp

final class GeoCodingAPITests: XCTestCase {

    func test_getCities_whenJsonValid_shouldReturnCities() async {
        let sut = GeoCodingAPI()
        sut.urlSession = SpyURLSession(jsonData: validJsonData())
        
        let cities = try? await sut.getCities(for: "London")
        
        XCTAssertNotNil(cities)
        XCTAssertEqual(cities?.count, 5)
        
        XCTAssertEqual(cities?[0].name, "London")
        XCTAssertEqual(cities?[0].lat, 51.5073219)
        XCTAssertEqual(cities?[0].lon, -0.1276474)
        XCTAssertEqual(cities?[0].country, "GB")
        XCTAssertEqual(cities?[0].state, "England")
        
        XCTAssertEqual(cities?[1].name, "City of London")
        XCTAssertEqual(cities?[1].lat, 51.5156177)
        XCTAssertEqual(cities?[1].lon, -0.0919983)
        XCTAssertEqual(cities?[1].country, "GB")
        XCTAssertEqual(cities?[1].state, "England")
        
        XCTAssertEqual(cities?[2].name, "London")
        XCTAssertEqual(cities?[2].lat, 42.9832406)
        XCTAssertEqual(cities?[2].lon, -81.243372)
        XCTAssertEqual(cities?[2].country, "CA")
        XCTAssertEqual(cities?[2].state, "Ontario")
        
        XCTAssertEqual(cities?[3].name, "Chelsea")
        XCTAssertEqual(cities?[3].lat, 51.4875167)
        XCTAssertEqual(cities?[3].lon, -0.1687007)
        XCTAssertEqual(cities?[3].country, "GB")
        XCTAssertEqual(cities?[3].state, "England")
        
        XCTAssertEqual(cities?[4].name, "London")
        XCTAssertEqual(cities?[4].lat, 37.1289771)
        XCTAssertEqual(cities?[4].lon, -84.0832646)
        XCTAssertEqual(cities?[4].country, "US")
        XCTAssertEqual(cities?[4].state, "Kentucky")
    }
    
    func test_getCities_whenJsonInvalid_shouldThrowDecodeError() async {
        let sut = GeoCodingAPI()
        sut.urlSession = SpyURLSession(jsonData: invalidJsonData())
        let expectation = XCTestExpectation(description: "Throw error")
        
        do {
            _ = try await sut.getCities(for: "London")
        } catch let error {
            XCTAssertEqual(error as? APIError, .decodeError)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
}

//MARK: Helpers

extension GeoCodingAPITests {
    
    private func validJsonData() -> Data {
     """
     [
        {
           "name":"London",
           "lat":51.5073219,
           "lon":-0.1276474,
           "country":"GB",
           "state":"England"
        },
        {
           "name":"City of London",
           "lat":51.5156177,
           "lon":-0.0919983,
           "country":"GB",
           "state":"England"
        },
        {
           "name":"London",
           "lat":42.9832406,
           "lon":-81.243372,
           "country":"CA",
           "state":"Ontario"
        },
        {
           "name":"Chelsea",
           "lat":51.4875167,
           "lon":-0.1687007,
           "country":"GB",
           "state":"England"
        },
        {
           "name":"London",
           "lat":37.1289771,
           "lon":-84.0832646,
           "country":"US",
           "state":"Kentucky"
        }
     ]
     """.data(using: .utf8)!
    }
    
    private func invalidJsonData() -> Data {
     """
     [
        {
           "name":"London",
           "lat":51.5073219,
           "lon":-0.1276474,
           "country":"GB",
           "state":"England"
        }
        {
           "name":"City of London",
           "lat":51.5156177,
           "lon":-0.0919983,
           "country":"GB",
           "state":"England"
        }
     ]
     """.data(using: .utf8)!
    }
    
}
