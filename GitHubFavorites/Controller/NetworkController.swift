//
//  NetworkController.swift
//  GitHubFavorites
//
//  Created by Jinsu Gu on 1/23/25.
//

import Foundation

class NetworkController {
    public static let shared = NetworkController()
    
    func fetchData(urlStr: String, completion: @escaping (Result<Data, Error>) -> Void) async {
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(.success(data))
                } else {
                    completion(.failure(NSError(domain: "Invalid HTTP response", code: httpResponse.statusCode)))
                }
            } else {
                completion(.failure(NSError(domain: "Wrong response type", code: -1)))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
