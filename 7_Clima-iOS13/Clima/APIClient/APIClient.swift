//
//  APIClient.swift
//  Clima
//
//  Created by 井本智博 on 2024/07/08.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalidURL, invalidResponse, invalidDecode
}

class APIClient {
    static let shared = APIClient()
    private init() {}

    func request<T: Decodable>(urlString: String, type: T.Type,  completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.setValue(R.string.localizable.contentType(), forHTTPHeaderField: R.string.localizable.accept())
        request.httpMethod = R.string.localizable.get()

        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in

            guard error == nil,
                  let data = data else { 
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(APIError.invalidDecode))
            }
        }
        task.resume()
    }
}
