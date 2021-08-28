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
    var movie = Movie(title: "", year: "", rate: "", plot: "", imdb: "")
    var searhQuery = ""
    
    public var firstView: FirstView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! FirstView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailViewController {
            detailVC.store = self.store
            detailVC.fetch(with: searhQuery)
        }
    }
    
    // _MARK: Custom funcs
    private func fetch(with query: String) {
        store.fetchMovie(for: query) { (movieResult) in
            switch movieResult {
            case let .success(movie):
                self.movie = movie
                print("Successfully found \(movie.title) for search query /\(query)/.")
            case let .failure(error):
                print("Error fetching movie: \(error)")
            }
        }
    }
    
    // _MARK: IBActions
    @IBAction func searchTapped(_ sender: UIButton) {
        if let query = firstView.searchTxtField.text{
            //fetch(with: query)
            self.searhQuery = query
        } else {
            //fetch(with: "it")
            self.searhQuery = "it"
        }
    }
    

}

