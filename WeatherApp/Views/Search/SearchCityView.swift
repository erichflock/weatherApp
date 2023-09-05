//
//  SearchCityView.swift
//  WeatherApp
//
//  Created by Erich.Flock on 03.09.23.
//

import SwiftUI

struct SearchCityView: View {
    
    @ObservedObject var viewModel: SearchCityViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.cities) { city in
                if let title = viewModel.createTitle(for: city) {
                    Text(title)
                        .listRowBackground(Color.clear)
                        .onTapGesture {
                            viewModel.didSelect(city: city)
                            dismiss()
                        }
                }
            }
            
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
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
        .overlay {
            if viewModel.cities.isEmpty {
                noDataAvailableView
            }
        }
        .background {
            WeatherGradientView()
        }
    }
    
    private var noDataAvailableView: some View {
        VStack(alignment: .center, spacing: 10) {
            Text("No cities. Please search it again.")
                .font(.system(size: 18))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 110)
            Image(systemName: "location.magnifyingglass")
                .font(.system(size: 50))
        }
        .offset(y: -50)
    }
}
