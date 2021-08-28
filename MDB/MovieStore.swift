//
//  MovieStore.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

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
    public func fetchImage(for movie: Movie, with compelition: @escaping (Result<UIImage, Error>) -> Void) {
        guard let imageUrl = movie.posterUrl else {
            compelition(.failure(MoviePosterError.missingImageUrl))
            return
        }
        let request = URLRequest(url: imageUrl)
        let task = session.dataTask(with: request) { (data, response, error) in
            let result = self.processImageRequest(data: data, error: error)
            compelition(result)
        }
        task.resume()
    }
    
    private func processMovieRequest(data: Data?, error: Error?) -> Result<Movie, Error> {
        guard let jsonData = data else {
            return .failure(error!)
        }
        
        return OMDBApi.fetchedMovie(fromJSON: jsonData)
    }
    
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        guard
            let imageData = data,
            let image = UIImage(data: imageData) else {
            if data == nil {
                return .failure(error!)
            } else {
                return .failure(MoviePosterError.imageCreation)
            }
        }
        return .success(image)
        
    }
    
    enum MoviePosterError: Error {
        case imageCreation
        case missingImageUrl
    }
}
