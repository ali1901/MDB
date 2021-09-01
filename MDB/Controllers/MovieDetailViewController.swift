//
//  MovieDetailViewController.swift
//  MDB
//
//  Created by Ali Safari on 8/24/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var store: MovieStore!
    var searchQuery = ""
    var savedMovieUrl: URL?
    var savedMovie: Movie?
    
    public var moveiDetaiLView: MovieDetailView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! MovieDetailView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let savedUrl = savedMovieUrl {
            loadMovie(from: savedUrl)
        }else {
            print(searchQuery + "------------")
            fetch(with: searchQuery)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        print("im gone brooooooooo")
    }
    
    // _MARK: Custom funcs
    public func fetch(with query: String) {
        store.fetchMovie(for: query) { (movieResult) in
            switch movieResult {
            case let .success(movie):
                DispatchQueue.main.async {
                    //self.movie = movie
                    self.setUpView(movie: movie)
                    //self.store.saveTheData(movie: movie)
                }
                
                print("Successfully found \(movie.title) for search query /\(query)/.")
            case let .failure(error):
                print("Error fetching movie: \(error)")
            }
        }
    }
    
    private func loadMovie(from url: URL) {
        self.savedMovie = store.loadMovie(from: url)
        setUpView(movie: savedMovie!)
    }
    
    private func setUpView(movie: Movie) {
        moveiDetaiLView.titleL.text = movie.title
        moveiDetaiLView.plotL.text = movie.plot
        moveiDetaiLView.ageL.text = movie.rate
        moveiDetaiLView.imdbL.text = "imdb: \(movie.imdbRating)"
        moveiDetaiLView.yearL.text = movie.year
        updateImageView(for: movie)
    }
    
    func updateImageView(for movie: Movie) {
        store.fetchImage(for: movie) { (imageResult) in
            switch imageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    self.moveiDetaiLView.posterImage.image = image
                }
            case let .failure(error):
                print("Error downloading Image: \(error)")
            }
        }
    }
}
