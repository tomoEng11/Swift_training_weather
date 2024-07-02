//
//  APIClient.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/02.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol DadJokeManagerDelegate {
    func updateDadJoke(jokeModel: JokeModel)
    func failedWithErrorForDadJoke(error: Error)
}

protocol WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel)
    func failedWithError(error: Error)
}

struct APIManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=4e415e4ab2aaed09e04d8419beedee19&units=metric"
    let decoder = JSONDecoder()

    var delegateForWeather: WeatherManagerDelegate?
    var delegateForJoke: DadJokeManagerDelegate?
}

//MARK: - DADJOKE MANAGER FUNCTION
extension APIManager {

    func fetchDadJokeData() {
        let url = URL(string: "https://icanhazdadjoke.com")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                self.delegateForJoke?.failedWithErrorForDadJoke(error: error!)
                return
            }

            do {
                let decodedData = try decoder.decode(JokeModel.self, from: data)
                print(decodedData)
                self.delegateForJoke?.updateDadJoke(jokeModel: JokeModel(joke: decodedData.joke))
            } catch {
                self.delegateForJoke?.failedWithErrorForDadJoke(error: error)
            }
        }
        task.resume()
    }
}

//MARK: - WEATHER MANAGER FUNCTIONS
extension APIManager {
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
                self.delegateForWeather?.failedWithError(error: error!)
                return
            }

            // "self" is necessery in closure
            self.delegateForWeather?.updateWeather(weatherModel: weather)
        }

        // what task do: go to url -> grab data -> come back

        // 4. Start the task
        task.resume()

    }   // [END] of performRequest()

    // decode JSON
    func parseJSON(weatherData: Data) -> WeatherModel? {
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("decoded: \(decodedData)")

            return WeatherModel(cityName: decodedData.name, conditionId: decodedData.weather[0].id, temperature: decodedData.main.temp)
        } catch {
            delegateForWeather?.failedWithError(error: error)
            return nil
        }
    }
}


