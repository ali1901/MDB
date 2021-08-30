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
    var searhQuery = ""
    let userDefaults = UserDefaults.standard
    
    public var firstView: FirstView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! FirstView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dir = store.documentDirectories
        var docDir = dir.first!
        if let movieTitles = userDefaults.value(forKey: "MovieTitles") {
            let titles = movieTitles as! [String]
            for item in titles {
                print("these are availible: \(item)")
                docDir.appendPathComponent("\(item).plist")
                loadMovies(url: docDir)
                docDir = docDir.deletingLastPathComponent()
                print ("this the address: \(docDir)")
//                print("these are availible: \(movie?.year)")
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstView.searchTxtField.text = ""
        searhQuery = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailViewController {
            detailVC.store = self.store
            if let text = firstView.searchTxtField.text {
                detailVC.searchQuery = text
            } else {
                detailVC.searchQuery = "it"
            }
        }
    }
    
    // _MARK: Custom funcs
//    private func fetch(with query: String) {
//        store.fetchMovie(for: query) { (movieResult) in
//            switch movieResult {
//            case let .success(movie):
//                self.movie = movie
//                print("Successfully found \(movie.title) for search query /\(query)/.")
//            case let .failure(error):
//                print("Error fetching movie: \(error)")
//            }
//        }
//    }
    
    private func loadMovies(url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let unarchiver = PropertyListDecoder()
            let movie = try unarchiver.decode(Movie.self, from: data)
            print("i got this: \(movie.title)")
        } catch {
            print(error)
        }
        
//        return movie
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
