//
//  WeatherDataManager.swift
//  Clima
//
//  Created by Daegeon Choi on 2020/04/15.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

//MARK: Delegate protocol
protocol WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

//MARK: DataManager struct
struct WeatherDataManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e415e4ab2aaed09e04d8419beedee19&units=metric"

    var delegate: WeatherManagerDelegate?

    //MARK:- fetchWeather
    func fetchWeather(_ city: String) {
        let completeURL = "\(baseURL)&q=\(city)"
        print(completeURL)
        performRequest(url: completeURL )
    }

    func fetchWeather(_ latitude: Double, _ longitude: Double) {
        let completeURL = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        print(completeURL)
        performRequest(url: completeURL )
    }

    //MARK: URL methods
    func performRequest(url: String) {
        // 1. Create URL
        guard let url = URL(string: url) else { return }

        // 2. Create URL Session
        let session = URLSession(configuration: .default)

        // 3. Give the session with task
        let task = session.dataTask(with: url) { (data, response, error) in
            // error check
            // Decode JSON

            guard error == nil,
                  let safeData = data,
                  let weather = self.parseJSON(weatherData: safeData) else {
                self.delegate?.failedWithError(error: error!)
                return
            }

            // "self" is necessery in closure
            self.delegate?.updateWeather(weatherModel: weather)
        }

        // what task do: go to url -> grab data -> come back

        // 4. Start the task
        task.resume()

    }   // [END] of performRequest()

    // decode JSON
    func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("decoded: \(decodedData)")

            return WeatherModel(cityName: decodedData.name, conditionId: decodedData.weather[0].id, temperature: decodedData.main.temp)

        } catch {
            delegate?.failedWithError(error: error)
            return nil
        }
    }
}
