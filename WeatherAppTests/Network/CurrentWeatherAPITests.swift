//
//  CurrentWeatherAPITests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 02.09.23.
//

import XCTest
@testable import WeatherApp

final class CurrentWeatherAPITests: XCTestCase {

    func test_fetchData_whenServerReturnsValidJson_shouldReturnResponseModel() async {
        let sut = CurrentWeatherAPI()
        sut.urlSession = SpyURLSession(jsonData: validJsonData())
        
        let responseModel = try? await sut.fetchData(lat: 10.0, lon: 10.0)
        
        XCTAssertNotNil(responseModel)
        XCTAssertEqual(responseModel?.coord?.lon, 10.99)
        XCTAssertEqual(responseModel?.coord?.lat, 44.34)
        XCTAssertEqual(responseModel?.weather?.first?.id, 501)
        XCTAssertEqual(responseModel?.weather?.first?.main, .Rain)
        XCTAssertEqual(responseModel?.weather?.first?.description, "moderate rain")
        XCTAssertEqual(responseModel?.main?.temp, 298.48)
        XCTAssertEqual(responseModel?.main?.tempMin, 297.56)
        XCTAssertEqual(responseModel?.main?.tempMax, 300.05)
    }
    
    func test_fetchData_whenInvalidJson_shouldThrowDecodeError() async {
        let sut = CurrentWeatherAPI()
        sut.urlSession = SpyURLSession(jsonData: invalidJsonData())
        let expectation = XCTestExpectation(description: "Throw error")
        
        do {
            _ = try await sut.fetchData(lat: 10.0, lon: 10.0)
        } catch let error {
            XCTAssertEqual(error as? CurrentWeatherAPIError, .decodeError)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
}

//MARK: Helpers
extension CurrentWeatherAPITests {
    
    private func invalidJsonData() -> Data {
     """
     {
       "coord": {
         "lon": 10.99,
         "lat": 44.34
       }
       "weather": [
         {
           "id": 501,
           "main": "Rain",
           "description": "moderate rain",
           "icon": "10d"
         }
       ]
       "main": {
         "temp": 298.48,
         "temp_min": 297.56,
         "temp_max": 300.05,
       }
     }
     """.data(using: .utf8)!
    }
    
    private func validJsonData() -> Data {
     """
     {
       "coord": {
         "lon": 10.99,
         "lat": 44.34
       },
       "weather": [
         {
           "id": 501,
           "main": "Rain",
           "description": "moderate rain",
           "icon": "10d"
         }
       ],
       "base": "stations",
       "main": {
         "temp": 298.48,
         "feels_like": 298.74,
         "temp_min": 297.56,
         "temp_max": 300.05,
         "pressure": 1015,
         "humidity": 64,
         "sea_level": 1015,
         "grnd_level": 933
       },
       "visibility": 10000,
       "wind": {
         "speed": 0.62,
         "deg": 349,
         "gust": 1.18
       },
       "rain": {
         "1h": 3.16
       },
       "clouds": {
         "all": 100
       },
       "dt": 1661870592,
       "sys": {
         "type": 2,
         "id": 2075663,
         "country": "IT",
         "sunrise": 1661834187,
         "sunset": 1661882248
       },
       "timezone": 7200,
       "id": 3163858,
       "name": "Zocca",
       "cod": 200
     }
     """.data(using: .utf8)!
    }
    
}

private class SpyURLSession: URLSessionProtocol {
    
    let jsonData: Data
    
    init(jsonData: Data) {
        self.jsonData = jsonData
    }
    
    func data(from url: URL, delegate: URLSessionTaskDelegate?) async throws -> (Data, URLResponse) {
        (jsonData, .init())
    }
    
}
