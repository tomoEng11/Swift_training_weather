//
//  DadJokeManager.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

protocol DadJokeManagerDelegate: AnyObject {
    func updateDadJoke(jokeModel: JokeModel)
    func failedWithError(error: Error)
}

struct DadJokeManager {

    var delegate: DadJokeManagerDelegate?

    func fetch() {
        APIClient.shared.request(urlString: R.string.localizable.dadjokeBaseURL(), type: JokeModel.self) { result in
            switch result {
            case .success(let jokeModel):
                delegate?.updateDadJoke(jokeModel: jokeModel)
            case .failure(let error):
                delegate?.failedWithError(error: error)
            }
        }
    }
}
