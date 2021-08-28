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
    
    public var moveiDetaiLView: MovieDetailView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! MovieDetailView)
    }
    
    var movie = Movie(title: "", year: "", rate: "", plot: "", imdb: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("did load the detail,:  \(movie.title)")
    }
    
    // _MARK: Custom funcs
    public func fetch(with query: String) {
        store.fetchMovie(for: query) { (movieResult) in
            switch movieResult {
            case let .success(movie):
                DispatchQueue.main.async {
                    self.movie = movie
                    self.setUpView()
                }
                
                print("Successfully found \(movie.title) for search query /\(query)/.")
            case let .failure(error):
                print("Error fetching movie: \(error)")
            }
        }
    }
    
    private func setUpView() {
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
