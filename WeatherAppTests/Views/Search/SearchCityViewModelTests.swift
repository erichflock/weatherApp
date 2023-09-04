//
//  SearchCityViewModelTests.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 04.09.23.
//

import XCTest
@testable import WeatherApp


final class SearchCityViewModelTests: XCTestCase {

    func test_clearCities_whenCalled_shouldRemoveCities() {
        let sut = SearchCityViewModel(geoCodingAPI: GeoCodingAPISpy())
        sut.cities = [.init(), .init()]
        XCTAssertFalse(sut.cities.isEmpty, "precondition")
        
        sut.clearCities()
        
        XCTAssertTrue(sut.cities.isEmpty)
    }
    
    func test_fethCities_whenSearchedCityEmpty_shouldNotCallGetCitiesOnGeoCodingAPI() async {
        let geoCodingAPISpy = GeoCodingAPISpy()
        let sut = SearchCityViewModel(geoCodingAPI: geoCodingAPISpy)
        XCTAssertTrue(sut.searchedCity.isEmpty, "precondition")
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 0, "precondition")
        
        await sut.fetchCities()
        
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 0)
    }
    
    func test_fethCities_whenSearchedCityNotEmpty_shouldCallGetCitiesOnGeoCodingAPI() async {
        let expectedReturnedApiCities: [GeoCodingCityAPIModel] = [.init(name: "London"),
                                                                  .init(name: "City of London")]
        let geoCodingAPISpy = GeoCodingAPISpy()
        geoCodingAPISpy.apiCities = expectedReturnedApiCities
        let sut = SearchCityViewModel(geoCodingAPI: geoCodingAPISpy)
        sut.searchedCity = "London"
        XCTAssertFalse(sut.searchedCity.isEmpty, "precondition")
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 0, "precondition")
        
        await sut.fetchCities()
        
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 1)
        XCTAssertEqual(geoCodingAPISpy.city, "London")
        XCTAssertEqual(geoCodingAPISpy.apiCities, expectedReturnedApiCities)
    }
    
    func test_fethCities_whenApiReturnsCities_shouldFulfillCities() async {
        let expectedReturnedApiCities: [GeoCodingCityAPIModel] = [.init(name: "London"),
                                                                  .init(name: "City of London")]
        let geoCodingAPISpy = GeoCodingAPISpy()
        geoCodingAPISpy.apiCities = expectedReturnedApiCities
        let sut = SearchCityViewModel(geoCodingAPI: geoCodingAPISpy)
        sut.searchedCity = "London"
        XCTAssertFalse(sut.searchedCity.isEmpty, "precondition")
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 0, "precondition")
        XCTAssertTrue(sut.cities.isEmpty, "precondition")
        
        await sut.fetchCities()
        await addDelayToAllowCitiesToBeUpdated()
        
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 1)
        XCTAssertEqual(geoCodingAPISpy.apiCities, expectedReturnedApiCities)
        XCTAssertEqual(sut.cities.count, expectedReturnedApiCities.count)
        XCTAssertEqual(sut.cities[0].name, expectedReturnedApiCities[0].name)
        XCTAssertEqual(sut.cities[1].name, expectedReturnedApiCities[1].name)
    }
    
    func test_fethCities_whenThrowsError_shouldClearCities() async {
        let geoCodingAPISpy = GeoCodingAPISpy()
        geoCodingAPISpy.error = APIError.fetchError
        let sut = SearchCityViewModel(geoCodingAPI: geoCodingAPISpy)
        sut.searchedCity = "London"
        sut.cities = [.init(), .init()]
        XCTAssertFalse(sut.searchedCity.isEmpty, "precondition")
        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 0, "precondition")
        XCTAssertFalse(sut.cities.isEmpty, "precondition")

        await sut.fetchCities()

        XCTAssertEqual(geoCodingAPISpy.getCitiesCallCount, 1)
        XCTAssertTrue(sut.cities.isEmpty)
    }
    
    func test_createTitleForCity_whenCityCountryAndStateAvailable_shouldReturnTitleWithCityCountryAndState() {
        let city: City = .init(name: "London",
                               country: "GB",
                               state: "England")
        let sut = SearchCityViewModel(geoCodingAPI: GeoCodingAPISpy())
        
        let title = sut.createTitle(for: city)
        
        XCTAssertEqual(title, "London, GB, England")
    }
    
    func test_createTitleForCity_whenCityAndCountryAvailable_shouldReturnTitleWithCityAndCountry() {
        let city: City = .init(name: "London",
                               country: "GB")
        let sut = SearchCityViewModel(geoCodingAPI: GeoCodingAPISpy())
        
        let title = sut.createTitle(for: city)
        
        XCTAssertEqual(title, "London, GB")
    }
    
    func test_createTitleForCity_whenCityAndStateAvailable_shouldReturnTitleWithCityAndState() {
        let city: City = .init(name: "London",
                               state: "England")
        let sut = SearchCityViewModel(geoCodingAPI: GeoCodingAPISpy())
        
        let title = sut.createTitle(for: city)
        
        XCTAssertEqual(title, "London, England")
    }
    
    func test_createTitleForCity_whenNoCityName_shouldReturnNil() {
        let cityWitCountryAndState: City = .init(country: "GB",
                                                 state: "England")
        let cityWitCountry: City = .init(country: "GB")
        let cityWitState: City = .init(state: "Engalnd")
        let emptyCity: City = .init()
        let sut = SearchCityViewModel(geoCodingAPI: GeoCodingAPISpy())
        
        XCTAssertNil(sut.createTitle(for: cityWitCountryAndState))
        XCTAssertNil(sut.createTitle(for: cityWitCountry))
        XCTAssertNil(sut.createTitle(for: cityWitState))
        XCTAssertNil(sut.createTitle(for: emptyCity))
    }
    
}

//MARK: Helpers
extension SearchCityViewModelTests {
    
    private func addDelayToAllowCitiesToBeUpdated(_ delayInSeconds: Int = 1) async {
        try? await Task.sleep(for: .seconds(delayInSeconds))
    }
    
}

private class GeoCodingAPISpy: GeoCodingAPIProtocol {
    
    var apiCities: [GeoCodingCityAPIModel]?
    var error: Error?
    private(set) var city: String?
    private(set) var getCitiesCallCount = 0
    
    func getCities(for city: String, limit: Int) async throws -> [GeoCodingCityAPIModel]? {
        getCitiesCallCount += 1
        self.city = city
        if let error {
            throw error
        }
        return apiCities
    }
    
}

extension GeoCodingCityAPIModel: Equatable {
    
    public static func == (lhs: GeoCodingCityAPIModel, rhs: GeoCodingCityAPIModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.lat == rhs.lat &&
        lhs.lon == rhs.lon &&
        lhs.country == rhs.country &&
        lhs.state == rhs.state
    }
    
}
