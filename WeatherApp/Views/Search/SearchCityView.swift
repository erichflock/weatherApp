//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI

struct SearchCityView: View {
    
    @ObservedObject var viewModel: SearchCityViewModel = .init()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.cities) { city in
                if let title = viewModel.createTitle(for: city) {
                    Text(title)
                }
            }
        }
        .navigationTitle("Search City")
        .searchable(text: $viewModel.searchedCity,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: Text("Search City"))
        .onChange(of: viewModel.searchedCity) { _ in
            viewModel.clearCities()
        }
        .onSubmit(of: .search) {
            Task {
                await viewModel.fetchCities()
            }
        }
    }
}
