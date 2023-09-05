//
//  CityViewModelTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 04.09.23.
//

import XCTest
@testable import WeatherApp

final class CityViewModelTests: XCTestCase {

    func test_temperatureUnit_whenChanged_shouldFetchWeatherData() async {
        let sut = CityViewModelSpy(currentWeatherAPI: CurrentWeatherAPISpy())
        XCTAssertEqual(sut.temperatureUnit, .celsius, "precondition")
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 0, "precondition")
        
        let task = Task {
            sut.temperatureUnit = .fahrenheit
        }
        
        await task.value
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 1)
    }
    
    func test_location_whenChanged_shouldFetchWeatherData() async {
        let sut = CityViewModelSpy(currentWeatherAPI: CurrentWeatherAPISpy())
        XCTAssertNil(sut.location)
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 0)
        
        let task = Task {
            sut.location = .init(latitude: 10, longitude: -10)
        }
        
        await task.value
        XCTAssertEqual(sut.fetchWeatherDataCallCount, 1)
    }
    
    func test_formatTemperature_shouldReturnStringWithoutDecimalPoints() {
        let sut = makeSUT()
        
        XCTAssertEqual(sut.format(temperature: 10.000), "10")
        XCTAssertEqual(sut.format(temperature: -11.500), "-12")
        XCTAssertEqual(sut.format(temperature: -11.400), "-11")
        XCTAssertEqual(sut.format(temperature: 50.10), "50")
        XCTAssertEqual(sut.format(temperature: -20.3333333333), "-20")
        XCTAssertEqual(sut.format(temperature: 110), "110")
    }
    
    func test_fetchWeatherData_whenWeatherDataFetched_weatherShouldHaveCorrectValues() async {
        let apiSpy = CurrentWeatherAPISpy()
        apiSpy.responseModel = createWeatherResponseModel()
        let sut = makeSUT(currentWeatherAPI: apiSpy)
        sut.location = .init(latitude: 10, longitude: 10)
        XCTAssertNil(sut.weather, "precondition")
        
        await sut.fetchWeatherData()
        await addDelay(1) //allow weather to be updated
        
        XCTAssertNotNil(sut.weather)
        XCTAssertEqual(sut.weather?.name, "London")
        XCTAssertEqual(sut.weather?.actualTemperature, 20.0)
        XCTAssertEqual(sut.weather?.minTemperature, 19.2)
        XCTAssertEqual(sut.weather?.maxTemperature, 25.3)
        XCTAssertEqual(sut.weather?.condition, .rain)
        XCTAssertEqual(sut.weather?.description, "Heavy rain")
    }
    
    func test_fetchWeatherData_whenError_weatherShouldBeNil() async {
        let apiSpy = CurrentWeatherAPISpy()
        apiSpy.error = .fetchError
        let sut = makeSUT(currentWeatherAPI: apiSpy)
        sut.location = .init(latitude: 10, longitude: 10)
        XCTAssertNil(sut.weather, "precondition")
        
        await sut.fetchWeatherData()
        await addDelay(1) //allow weather to be updated
        
        XCTAssertNil(sut.weather)
    }
    
}

//MARK: Helpers
extension CityViewModelTests {
    
    func makeSUT(currentWeatherAPI: CurrentWeatherAPIProtocol = CurrentWeatherAPISpy()) -> CityViewModel {
        .init(currentWeatherAPI: currentWeatherAPI)
    }
    
    func createWeatherResponseModel() -> CurrentWeatherAPIResponseModel {
        .init(coord: .init(lon: 10, lat: -10),
              weather: [.init(id: 10, main: .Rain, description: "Heavy rain")],
              main: .init(temp: 20.0, tempMin: 19.2, tempMax: 25.3),
              name: "London")
    }
    
}

private class CurrentWeatherAPISpy: CurrentWeatherAPIProtocol {
    
    var responseModel: CurrentWeatherAPIResponseModel?
    var error: APIError?
    
    private(set) var fetchDataCallCount = 0
    private(set) var units: CurrentWeatherAPIUnit?
    
    func fetchData(lat: Double, lon: Double, units: WeatherApp.CurrentWeatherAPIUnit) async throws -> WeatherApp.CurrentWeatherAPIResponseModel? {
        fetchDataCallCount += 1
        self.units = units
        if let error {
            throw error
        }
        return responseModel
    }
    
}

private class CityViewModelSpy: CityViewModel {
    
    private(set) var fetchWeatherDataCallCount = 0
    
    override func fetchWeatherData() async {
        fetchWeatherDataCallCount += 1
    }
    
}
