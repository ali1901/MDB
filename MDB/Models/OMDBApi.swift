//
//  OMDBApi.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import Foundation

//enum endPoint: String {
//    case search =
//}

struct OMDBApi {
    private static let basesUrlString = "https://www.omdbapi.com/?"
    private static let apiKey = "77fab3b"
    
    private static func omdbUrl(parameters: [String:String]?) -> URL {
        var components = URLComponents(string: basesUrlString)!
        var queryItems = [URLQueryItem]()
        
        let baseParametes = ["apikey": apiKey, "plot": "full"]
        for (key, value) in baseParametes {
            let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        
        
        if let additionalPrams = parameters {
            for (key, value) in additionalPrams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    static var searchByTitleUrl: URL {
        return omdbUrl(parameters: ["t":"tenet"])
    }
}
