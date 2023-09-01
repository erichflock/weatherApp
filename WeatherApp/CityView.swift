//
//  CityView.swift
//  weatherApp
//
//  Created by Erich.Flock on 01.09.23.
//

import SwiftUI

struct CityView: View {
    
    var body: some View {
        VStack() {
            mainContent
                .padding(.bottom, 150)
            Button("Search City", action: {
                
            })
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
        }
    }
    
    private var mainContent: some View {
        VStack(alignment: .center, spacing: 8) {
            VStack(alignment: .leading) {
                Text("Leipzig")
                    .font(.largeTitle)
                Text("30°")
                    .font(.system(size: 80))
            }
            HStack {
                VStack {
                    Text("Rain")
                        .font(.system(size: 20))
                    Text("moderate rain")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                Image(systemName: "cloud.rain.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(.gray, .blue)
                    .font(.system(size: 20))
            }
            HStack {
                Text("H: 20°")
                Text("L: 10°")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CityView()
    }
}
