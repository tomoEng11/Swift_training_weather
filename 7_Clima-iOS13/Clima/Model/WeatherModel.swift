//
//  WeatherModel.swift
//  Clima
//
//  Created by Daegeon Choi on 2020/04/28.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temperature: Double
    
    var temperatureString: String {
        return String.init(format: "%.1f", temperature)
    }

    // computed property
    var conditionName: String {
        // docs https://openweathermap.org/weather-conditions
        switch conditionId/100 {
        case 2:
            return R.string.localizable.cloudBolt()
        case 3:
            return R.string.localizable.cloudDrizzle()
        case 5:
            return R.string.localizable.cloudRain()
        case 6:
            return R.string.localizable.cloudSnow()
        case 7:
            return R.string.localizable.cloudFog()
        case 8:
            if conditionId == 800 {
                return R.string.localizable.sunMax()
            } else {
                return R.string.localizable.cloudBolt()
            }
        default:
            return R.string.localizable.cloud()
        }
    }
}
