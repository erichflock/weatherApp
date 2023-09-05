//
//  WeatherGradientView.swift
//  WeatherApp
//
//  Created by Erich.Flock on 05.09.23.
//

import SwiftUI

struct WeatherGradientView: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let colorsOfDarkSky = [Color(red: 0, green: 0, blue: 0.1), Color.gray]
    let colorsOfLightSky = [Color(red: 0.8, green: 0.9, blue: 0.98), Color.white]
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: colorScheme == .dark ? colorsOfDarkSky : colorsOfLightSky),
                              startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
    }
}

struct WeatherGradientView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherGradientView()
    }
}
