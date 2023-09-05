//
//  TestHelpers.swift
//  WeatherAppTests
//
//  Created by Erich.Flock on 05.09.23.
//

func addDelay(_ delayInSeconds: Int = 1) async {
    try? await Task.sleep(for: .seconds(delayInSeconds))
}
