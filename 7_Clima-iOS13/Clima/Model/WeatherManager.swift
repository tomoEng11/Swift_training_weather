//
//  WeatherManager.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/10.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate: AnyObject {
    func updateWeather(weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

struct WeatherManager {

    var delegate: WeatherManagerDelegate?

    func fetch(_ city: String) {
        APIClient.shared.request(urlString: createEndpoint(city) , type: WeatherData.self) { result in
            switch result {
            case .success(let weatherData):
                let weatherModel = WeatherModel(cityName: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp)
                delegate?.updateWeather(weatherModel: weatherModel )
            case .failure(let error):
                delegate?.failedWithError(error: error)
            }
        }
    }

    func fetch(_ latitude: Double, _ longitude: Double) {
        APIClient.shared.request(urlString: createEndpoint(latitude, longitude) , type: WeatherData.self) { result in
            switch result {
            case .success(let weatherData):
                let weatherModel = WeatherModel(cityName: weatherData.name, conditionId: weatherData.weather[0].id, temperature: weatherData.main.temp)
                delegate?.updateWeather(weatherModel: weatherModel )
            case .failure(let error):
                delegate?.failedWithError(error: error)
            }
        }
    }


    func createEndpoint(_ latitude: Double, _ longitude: Double) -> String {
        return "\(R.string.localizable.weatherBaseURL())&lat=\(latitude)&lon=\(longitude)"
    }

    func createEndpoint(_ city: String) -> String {
        return "\(R.string.localizable.weatherBaseURL())&q=\(city)"
    }

}
