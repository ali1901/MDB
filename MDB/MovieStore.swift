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
    
    let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    private var titles = [String]()

    private var movieArchiveUrl = URL(fileURLWithPath: "")
    
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
    
//    public func downloadImage(for movie: Movie) -> UIImage {
//        let imageUrl = movie.posterUrl
//        let request = URLRequest(url: imageUrl!)
//        let task = session.dataTask(with: request) { (data, response, error) in
//            if let imageData = data {
//                let image = UIImage(data: imageData)
//                return image!
//            }
//        }
//        task.resume()
//        
//    }

    
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
        
    public func saveTheData(movie: Movie) -> Bool {
        
        saveMovieTitles(movie: movie)
        
        var docDirectory = documentDirectories.first!
        docDirectory.appendPathComponent("\(movie.title).plist")
        movieArchiveUrl = docDirectory
        
        print("Saving movie to: \(movieArchiveUrl) ")
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(movie)
            try data.write(to: movieArchiveUrl, options: [.atomic])
            return true
        } catch {
            print("Error encoding the movie: \(error)")
            return false
        }
    }
    
    private func saveMovieTitles(movie: Movie) {
        let userDefaults = UserDefaults.standard
        if let movieTitles = userDefaults.value(forKey: "MovieTitles") {
            titles = movieTitles as! [String]
        }
        titles.append(movie.title)
        titles = duplicateRemover(array: titles)
        for item in titles {
            print("this is in me: \(item)")
        }
        userDefaults.set(titles, forKey: "MovieTitles")
    }
    
    public func loadMovie(from url: URL) -> Movie? {
        do {
            let data = try Data(contentsOf: url)
            let unArchiver = PropertyListDecoder()
            let movie = try unArchiver.decode(Movie.self, from: data)
            return movie
        } catch {
            print("Error loading movie: \(error)")
        }
        return nil
    }
    
    private func duplicateRemover(array: [String]) -> [String] {
        let uniqueOrdered = Array(NSOrderedSet(array: array)) as! [String]
        return uniqueOrdered
    }
}
