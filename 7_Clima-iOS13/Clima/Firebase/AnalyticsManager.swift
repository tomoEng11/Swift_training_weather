//
//  AnalyticsManager.swift
//  Clima
//
//  Created by 井本智博 on 2024/09/22.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init(){}


    func logEventForTapDadJoke(event: String, parameters : [String:Any]) {
        Analytics.logEvent(event, parameters: parameters)
        print(event, parameters)
    }

    func logEvent(name: String, params: [String:Any]? = nil) {
        Analytics.logEvent(name, parameters: params)
    }
}
