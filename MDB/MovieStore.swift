//
//  MovieStore.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import Foundation

class MovieStore {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    public func fetchMovie() {
        let url = OMDBApi.searchByTitleUrl
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let jsonData = data {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else if let requestError = error {
                    print("Error fetching data: \(requestError)")
                } else {
                    print("Unexpected Error!")
                }
            }
        }
        task.resume()
    }
}
