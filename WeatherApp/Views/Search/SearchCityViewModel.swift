//
//  SearchCityViewModel.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI

final class SearchCityViewModel: ObservableObject {
    
    @Published var searchedCity: String = ""
}
