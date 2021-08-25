//
//  Movie.swift
//  MDB
//
//  Created by Ali Safari on 8/25/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import Foundation

class Movie: Codable {
    let title: String
    let year: String
    let rate: String
    let plot: String
    let imdbRating: String
    let posterUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rate = "Rated"
        case plot = "Plot"
        case imdbRating
        case posterUrl = "Poster"
    }
}
