//
//  FavoritesViewController.swift
//  MDB
//
//  Created by Ali Safari on 9/6/21.
//  Copyright © 2021 Ali Safari. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    var favoirtesView: FavoritesView! {
        guard isViewLoaded else {
            return nil
        }
        return (view as! FavoritesView)
    }
        
    var store: MovieStore!
    var movies = [Movie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movies = store.loadMoviesAdresses(for: "Favorites")
    }

}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FavoritesTableViewCell
        store.fetchImage(for: movies[indexPath.row], with: { (imgRes) in
            switch imgRes {
            case let .success(image):
                OperationQueue.main.addOperation {
                    cell.posterImageView.image = image
                }
            case let .failure(er):
                print(er)
            }
        })
        cell.titleLabel.text = movies[indexPath.row].title
        cell.subTLabel.text = movies[indexPath.row].year
    
        return cell
    }
    
    
}
