//
//  CityDetailViewController.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/03.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!

    @IBOutlet weak var temperatureLabel: UILabel!

    @IBOutlet weak var cityLabel: UILabel!
    
    var cityName: String!
    var api = APIManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        api.delegateForWeather = self
        api.fetchWeather(cityName)
        self.navigationItem.title = cityName
    }
}

extension CityDetailViewController: WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.sync {
            self.temperatureLabel.text = weatherModel.temperatureString
            self.cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }
    
    func failedWithError(error: any Error) {
        print(error)
    }
}
