//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    @IBOutlet weak var dadjokeLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var dadjokeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    //MARK: Properties

    var api = APIManager()
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        searchField.delegate = self
        api.delegateForJoke = self
        api.delegateForWeather = self

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:  .plain, target: nil, action: nil)
        dadjokeButton.setTitle(R.string.localizable.dadjoke(), for: .normal)
        favoriteButton.setTitle(R.string.localizable.favorite(), for: .normal)

    }
    
    @IBAction func dadjokeButtonPressed(_ sender: UIButton) {
        api.fetchDadJokeData()
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        let vc = CityListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- TextField extension
extension WeatherViewController: UITextFieldDelegate {

    @IBAction func searchBtnClicked(_ sender: UIButton) {
        searchField.endEditing(true)    //dismiss keyboard
        print(searchField.text!)

        searchWeather()
    }

    func searchWeather() {
        guard let cityName = searchField.text else { return }
        api.fetchWeather(cityName)
        print("action: search, city: \(cityName)")
    }

    // when keyboard return clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)    //dismiss keyboard
        print(searchField.text!)

        searchWeather()
        return true
    }

    // when textfield deselected
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // by using "textField" (not "searchField") this applied to any textField in this Controller(cuz of delegate = self)
        guard let searchText = textField.text,
              !searchText.isEmpty
        else {
            textField.placeholder = R.string.localizable.textFieldPlaceholder()
            return false
        }
        return true
    }

    // when textfield stop editing (keyboard dismissed)
    func textFieldDidEndEditing(_ textField: UITextField) {
        //        searchField.text = ""   // clear textField
    }
}

//MARK:- View update extension
extension WeatherViewController: WeatherManagerDelegate {

    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.sync {
            self.temperatureLabel.text = weatherModel.temperatureString
            self.cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
            self.changeBackground(cityName: weatherModel.cityName)
        }
    }

    func failedWithError(error: Error) {
        print(error)
    }
}

// MARK:- CLLocation
extension WeatherViewController: CLLocationManagerDelegate {

    @IBAction func locationButtonClicked(_ sender: UIButton) {
        // Get permission
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        api.fetchWeather(lat, lon)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

private extension WeatherViewController {
    func changeBackground(cityName: String) {
        if cityName == R.string.localizable.tokyo() {
            backgroundImage.image = UIImage(named: R.string.localizable.appIcon())
        } else {
            backgroundImage.image = UIImage(resource: R.image.background)
        }
    }
}

extension WeatherViewController: DadJokeManagerDelegate {
    func failedWithErrorForDadJoke(error: any Error) {
        print(error)
    }
    
    func updateDadJoke(jokeModel: JokeModel) {
        DispatchQueue.main.async {
            self.dadjokeLabel.text = jokeModel.joke
        }
    }
}
