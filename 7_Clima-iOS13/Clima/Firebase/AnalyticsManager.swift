//
//  AnalyticsManager.swift
//  Clima
//
//  Created by 井本智博 on 2024/09/22.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class AnalyticsManager {
    private init(){}
    static let shared = AnalyticsManager()

    func logEventForTapDadJoke(event: String, parameters : [String:Any]) {
        Analytics.logEvent(event, parameters: parameters)
        print(event, parameters)
    }
}
