//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI

struct SearchCityView: View {
    
    @ObservedObject var viewModel: SearchCityViewModel = .init()
    
    var body: some View {
        List {
            Text("Leipzig")
            Text("London")
        }
        .navigationTitle("Search City")
        .searchable(text: $viewModel.searchedCity,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search City"))
    }
}
