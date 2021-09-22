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
    
    public func loadMovie(withTitle title: String) -> Movie? {
        if let movie = try? dc.load(toObject: Movie.self, withName: title) {
            return movie
        } else {
            return nil
        }
    }
    
    public func saveMovie(movie: Movie) throws {
        try dc.save(theObject: movie, withName: movie.title)
    }
}
