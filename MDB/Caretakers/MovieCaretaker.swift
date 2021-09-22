//
//  MovieCaretaker.swift
//  MDB
//
//  Created by Ali Safari on 9/22/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import Foundation

class MovieCaretaker {
    
    let dc = DiskCaretaker()
    private var titles = [String]()
    private var favoriteTitles = [String]()
    
    public func loadMovie(withTitle title: String) -> Movie? {
        if let movie = try? dc.load(toObject: Movie.self, withName: title) {
            return movie
        } else {
            return nil
        }
    }
    
    public func saveMovie(movie: Movie) throws {
        saveMovieTitles(movie: movie, with: "MovieTitles")
        try dc.save(theObject: movie, withName: movie.title)
    }
    
    
    public func saveMovieTitles(movie: Movie, with key: String) {
        let userDefaults = UserDefaults.standard
        switch key {
        case "MovieTitles":
            if let movieTitles = userDefaults.value(forKey: "MovieTitles") {
                titles = movieTitles as! [String]
            }
            titles.append(movie.title)
            titles = duplicateRemover(array: titles)
            for item in titles {
                print("this is in me: \(item)")
            }
            userDefaults.set(titles, forKey: "MovieTitles")
        case "Favorites":
            if let movieTitles = userDefaults.value(forKey: "Favorites") {
                favoriteTitles = movieTitles as! [String]
            }
            for item in favoriteTitles {
                print("this is in favesssssss: \(item)")
            }
            favoriteTitles.append(movie.title)
            favoriteTitles = duplicateRemover(array: favoriteTitles)
            userDefaults.set(favoriteTitles, forKey: "Favorites")
        default:
            break
        }
        
       }
    
    private func duplicateRemover(array: [String]) -> [String] {
        let uniqueOrdered = Array(NSOrderedSet(array: array)) as! [String]
        return uniqueOrdered
    }
    
}
