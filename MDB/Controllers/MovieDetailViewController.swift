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
    var imageStore: ImageStore!
    let mc = MovieCaretaker()
    
    var searchQuery = ""
//    var savedMovieUrl: URL?
    var savedMovie: Movie? = nil
    
    public var moveiDetaiLView: MovieDetailView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! MovieDetailView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(savedMovie?.title ?? "dalasMavs" + "+++++++++++++++++++++++++++++++")
        // Do any additional setup after loading the view.
        if let saved = savedMovie {
            setUpView(movie: saved)
            updateImageViewfromDisk(for: saved)
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
                    self.savedMovie = movie
                    self.setUpView(movie: movie)
                    self.updateImageView(for: movie)
//                    self.store.saveTheData(movie: movie)
                    try? self.mc.saveMovie(movie: movie) //saving movie through caretaker
                    
                }
                
                print("Successfully found \(movie.title) for search query /\(query)/.")
            case let .failure(error):
                print("Error fetching movie: \(error)")
            }
        }
    }
    
//    private func loadMovie(from url: URL) {
//        self.savedMovie = store.loadMovie(from: url)
//        setUpView(movie: savedMovie!)
//    }
    
    private func setUpView(movie: Movie) {
        moveiDetaiLView.titleL.text = movie.title
        moveiDetaiLView.plotL.text = movie.plot
        moveiDetaiLView.ageL.text = movie.rate
        moveiDetaiLView.imdbL.text = "imdb: \(movie.imdbRating)"
        moveiDetaiLView.yearL.text = movie.year
    }
    
    func updateImageView(for movie: Movie) {
        store.fetchImage(for: movie) { (imageResult) in
            switch imageResult {
            case let .success(image):
                DispatchQueue.main.async {
                    self.moveiDetaiLView.posterImage.image = image
                    self.imageStore.setImage(image, forKey: movie.title)
                }
            case let .failure(error):
                print("Error downloading Image: \(error)")
            }
        }
    }
    
    func updateImageViewfromDisk(for movie: Movie) {
        let image = self.imageStore.image(forKey: movie.title)
        self.moveiDetaiLView.posterImage.image = image
    }
    
    // MARK: - IBActions
    @IBAction func addToFavorites(_ sender: UIBarButtonItem) {
        if let movie = savedMovie {
            print ("2-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/ \(movie.title)")
            store.saveMovieTitles(movie: movie, with: "Favorites")
        }
    }
}
