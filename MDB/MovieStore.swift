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
    
    public func fetchMovie(for title: String, with completion: @escaping (Result<Movie, Error>) -> Void) {
        OMDBApi.tittleToSearchFor(title: title)
        let url = OMDBApi.searchByTitleUrl
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in

            let result = self.processMovieRequest(data: data, error: error)
            completion(result)
        }
        task.resume()
    }
    
    private func processMovieRequest(data: Data?, error: Error?) -> Result<Movie, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return OMDBApi.movie(fromJSON: jsonData)
    }
}
