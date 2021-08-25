//
//  ViewController.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var store: MovieStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        store.fetchMovie()
        store.fetchMovie { (movieResult) in
            switch movieResult {
            case let .success(movie):
                print("Successfully found \(movie.title) for search query /tenet/.")
            case let .failure(error):
                print("Error fetching movie: \(error)")
            }
        }
    }


}

